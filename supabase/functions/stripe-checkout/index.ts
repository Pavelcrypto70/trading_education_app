// Web payments via Stripe Checkout (optional).
// Env: STRIPE_SECRET_KEY, STRIPE_PRICE_ID, SITE_URL

import Stripe from "https://esm.sh/stripe@14.21.0?target=deno";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const stripeKey = Deno.env.get("STRIPE_SECRET_KEY");
  const priceId = Deno.env.get("STRIPE_PRICE_ID");
  const siteUrl = Deno.env.get("SITE_URL") ?? "https://pavelcrypto70.github.io";

  if (!stripeKey || !priceId) {
    return json({ ok: false, error: "stripe_not_configured" }, 503);
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader) {
    return json({ ok: false, error: "missing_auth" }, 401);
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: authHeader } } },
  );
  const { data: userData, error: userError } = await supabase.auth.getUser();
  if (userError || !userData.user) {
    return json({ ok: false, error: "invalid_auth" }, 401);
  }

  const stripe = new Stripe(stripeKey, { apiVersion: "2023-10-16" });
  const session = await stripe.checkout.sessions.create({
    mode: "payment",
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: `${siteUrl}/#/premium?checkout=success`,
    cancel_url: `${siteUrl}/#/premium?checkout=cancel`,
    client_reference_id: userData.user.id,
    customer_email: userData.user.email ?? undefined,
    metadata: {
      user_id: userData.user.id,
      product_id: "trade_master_lifetime_full",
    },
  });

  return json({ ok: true, url: session.url });
});

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
