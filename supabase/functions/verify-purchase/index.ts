// Verifies in-app purchase and grants premium server-side.
// Secrets: GOOGLE_PLAY_SERVICE_ACCOUNT_JSON (Android verification)

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";
import { GoogleAuth } from "npm:google-auth-library@9";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const LIFETIME_PRODUCT_ID = "trade_master_lifetime_full";
const ANDROID_PACKAGE = "com.trademaster.education";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return json({ ok: false, error: "missing_auth" }, 401);
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    const userClient = createClient(supabaseUrl, Deno.env.get("SUPABASE_ANON_KEY")!, {
      global: { headers: { Authorization: authHeader } },
    });
    const { data: userData, error: userError } = await userClient.auth.getUser();
    if (userError || !userData.user) {
      return json({ ok: false, error: "invalid_auth" }, 401);
    }

    const body = await req.json();
    const { productId, platform, transactionId, receiptData } = body as {
      productId?: string;
      platform?: string;
      transactionId?: string;
      receiptData?: string;
    };

    if (!productId || !platform || !transactionId) {
      return json({ ok: false, error: "missing_fields" }, 400);
    }

    if (productId !== LIFETIME_PRODUCT_ID) {
      return json({ ok: false, error: "invalid_product" }, 400);
    }

    const verified = await verifyStorePurchase(platform, productId, receiptData, transactionId);
    if (!verified) {
      return json({ ok: false, error: "verification_failed" }, 403);
    }

    const admin = createClient(supabaseUrl, serviceKey);
    const { error: rpcError } = await admin.rpc("grant_premium_from_purchase", {
      p_user_id: userData.user.id,
      p_product_id: productId,
      p_platform: platform,
      p_transaction_id: transactionId,
      p_receipt_data: receiptData ?? null,
    });

    if (rpcError) {
      console.error(rpcError);
      return json({ ok: false, error: "grant_failed" }, 500);
    }

    return json({ ok: true, isPremium: true });
  } catch (e) {
    console.error(e);
    return json({ ok: false, error: "server_error" }, 500);
  }
});

async function verifyStorePurchase(
  platform: string,
  productId: string,
  receiptData: string | undefined,
  transactionId: string,
): Promise<boolean> {
  if (platform === "android") {
    return verifyGooglePlay(productId, receiptData ?? transactionId);
  }
  if (platform === "ios") {
    return verifyApple(receiptData);
  }
  if (platform === "stripe") {
    return true; // stripe-webhook already verified
  }
  // Dev / staging without store keys: reject unknown platforms
  return false;
}

async function verifyGooglePlay(productId: string, purchaseToken: string): Promise<boolean> {
  const saJson = Deno.env.get("GOOGLE_PLAY_SERVICE_ACCOUNT_JSON");
  if (!saJson) {
    console.warn("GOOGLE_PLAY_SERVICE_ACCOUNT_JSON not set");
    return false;
  }

  try {
    const credentials = JSON.parse(saJson);
    const auth = new GoogleAuth({
      credentials,
      scopes: ["https://www.googleapis.com/auth/androidpublisher"],
    });
    const client = await auth.getClient();
    const accessToken = await client.getAccessToken();
    if (!accessToken.token) return false;

    const url =
      `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${ANDROID_PACKAGE}/purchases/products/${productId}/tokens/${encodeURIComponent(purchaseToken)}`;

    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${accessToken.token}` },
    });

    if (!res.ok) {
      console.error("Google Play API", res.status, await res.text());
      return false;
    }

    const data = await res.json();
    // purchaseState: 0 = purchased, 1 = canceled, 2 = pending
    return data.purchaseState === 0;
  } catch (e) {
    console.error("verifyGooglePlay", e);
    return false;
  }
}

async function verifyApple(receiptData: string | undefined): Promise<boolean> {
  const sharedSecret = Deno.env.get("APPLE_SHARED_SECRET");
  if (!sharedSecret || !receiptData) return false;

  const payload = {
    "receipt-data": receiptData,
    password: sharedSecret,
    "exclude-old-transactions": true,
  };

  const prodUrl = "https://buy.itunes.apple.com/verifyReceipt";
  let res = await fetch(prodUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  let data = await res.json();

  if (data.status === 21007) {
    res = await fetch("https://sandbox.itunes.apple.com/verifyReceipt", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    data = await res.json();
  }

  return data.status === 0;
}

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
