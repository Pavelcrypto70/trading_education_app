// Permanently deletes the authenticated user and cascaded app data.
// Required for Apple App Store Guideline 5.1.1 (account deletion).

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

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return json({ ok: false, error: "missing_auth" }, 401);
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;

    const userClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const { data: userData, error: userError } = await userClient.auth.getUser();
    if (userError || !userData.user) {
      return json({ ok: false, error: "invalid_auth" }, 401);
    }

    const userId = userData.user.id;
    const admin = createClient(supabaseUrl, serviceKey);

    // Explicit cleanup (FK cascade also covers these on auth.users delete).
    await admin.from("purchases").delete().eq("user_id", userId);
    await admin.from("referral_redemptions").delete().eq("redeemer_id", userId);
    await admin.from("user_progress").delete().eq("user_id", userId);
    await admin.from("user_profiles").delete().eq("id", userId);

    const { error: deleteError } = await admin.auth.admin.deleteUser(userId);
    if (deleteError) {
      console.error(deleteError);
      return json({ ok: false, error: "delete_failed" }, 500);
    }

    return json({ ok: true });
  } catch (e) {
    console.error(e);
    return json({ ok: false, error: "server_error" }, 500);
  }
});

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
