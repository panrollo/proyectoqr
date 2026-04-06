import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, "..", "");
  const host = env.VITE_DEV_HOST || "127.0.0.1";
  const port = Number(env.VITE_DEV_PORT || 5173);
  const allowedHosts = (env.VITE_ALLOWED_HOSTS || "")
    .split(",")
    .map((value) => value.trim())
    .filter(Boolean);

  return {
    envDir: "..",
    plugins: [react()],
    server: {
      host,
      port,
      strictPort: true,
      ...(allowedHosts.length ? { allowedHosts } : {}),
    },
    preview: {
      host,
      port,
    },
  };
});
