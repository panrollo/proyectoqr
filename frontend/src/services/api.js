function isLocalHostname(hostname) {
  return hostname === "127.0.0.1" || hostname === "localhost";
}

function resolveApiBaseUrl() {
  const configuredBaseUrl = import.meta.env.VITE_API_URL?.trim();
  if (configuredBaseUrl) {
    return configuredBaseUrl.replace(/\/+$/, "");
  }

  const { protocol, hostname, origin } = window.location;
  if (isLocalHostname(hostname)) {
    return `${protocol}//${hostname}:8000/api`;
  }

  return `${origin}/api`;
}

export const API_BASE_URL = resolveApiBaseUrl();
let sessionToken = "";


export function setApiToken(token) {
  sessionToken = token || "";
}

async function request(path, options = {}) {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    headers: {
      "Content-Type": "application/json",
      ...(sessionToken ? { Authorization: `Bearer ${sessionToken}` } : {}),
      ...(options.headers || {}),
    },
    ...options,
  });

  const contentType = response.headers.get("content-type") || "";
  const text = await response.text();
  let data = null;

  if (text) {
    if (contentType.includes("application/json")) {
      try {
        data = JSON.parse(text);
      } catch (_error) {
        data = null;
      }
    } else {
      data = { raw: text };
    }
  }

  if (!response.ok) {
    const responseMessage =
      data?.detail ||
      data?.message ||
      (response.status >= 500
        ? `La API no respondio correctamente (${response.status}).`
        : "Request failed.");

    throw new Error(responseMessage);
  }

  return data;
}

export const api = {
  get: (path) => request(path),
  post: (path, body) =>
    request(path, {
      method: "POST",
      body: JSON.stringify(body),
    }),
  put: (path, body) =>
    request(path, {
      method: "PUT",
      body: JSON.stringify(body),
    }),
  delete: (path) =>
    request(path, {
      method: "DELETE",
    }),
};
