import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, "..", "");
  const host = env.VITE_DEV_HOST || "127.0.0.1";
  const port = Number(env.VITE_DEV_PORT || 5173);

  return {
    envDir: "..",
    plugins: [react()],
    server: {
      host,
      port,
      strictPort: true,
          allowedHosts: [
      "cheerful-freedom-production.up.railway.app",]
    },
    preview: {
      host,
      port,
    },
  };
});
