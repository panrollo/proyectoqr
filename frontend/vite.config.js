import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";

function toHostname(value) {
  if (!value) return "";
  const trimmed = value.trim();
  if (!trimmed) return "";

  try {
    return new URL(trimmed).hostname;
  } catch (_error) {
    return trimmed.replace(/^https?:\/\//, "").replace(/\/.*$/, "");
  }
}

function resolveAllowedHosts(env, mode) {
  const candidates = [
    "cheerful-freedom-production.up.railway.app",
    ...(env.VITE_ALLOWED_HOSTS || "").split(","),
    env.RAILWAY_PUBLIC_DOMAIN || "",
    env.RAILWAY_PUBLIC_URL || "",
    env.RAILWAY_STATIC_URL || "",
  ];

  const hosts = [];
  const seen = new Set();

  for (const candidate of candidates) {
    const hostname = toHostname(candidate);
    if (!hostname || seen.has(hostname)) continue;
    seen.add(hostname);
    hosts.push(hostname);
  }

  if (hosts.length) {
    return hosts;
  }

  if (mode !== "development") {
    return true;
  }

  return undefined;
}

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, "..", "");
  const host = env.VITE_DEV_HOST || "127.0.0.1";
  const port = Number(env.VITE_DEV_PORT || 5173);
  const allowedHosts = resolveAllowedHosts({ ...process.env, ...env }, mode);

  return {
    envDir: "..",
    plugins: [react()],
    server: {
      host,
      port,
      strictPort: true,
      ...(allowedHosts !== undefined ? { allowedHosts } : {}),
    },
    preview: {
      host,
      port,
      ...(allowedHosts !== undefined ? { allowedHosts } : {}),
    },
  };
});
