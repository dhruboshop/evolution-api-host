const startedAt = new Date().toISOString();

function safeError(error) {
  if (error instanceof Error) {
    return {
      name: error.name,
      message: error.message,
      stack: error.stack
    };
  }
  return { message: String(error) };
}

function log(event, extra = {}) {
  console.error(JSON.stringify({
    level: event.includes("Exception") || event.includes("Rejection") ? "error" : "warn",
    source: "zappy-evolution-diagnostics",
    event,
    pid: process.pid,
    uptimeSeconds: Math.round(process.uptime()),
    startedAt,
    time: new Date().toISOString(),
    ...extra
  }));
}

process.on("SIGTERM", () => {
  log("SIGTERM");
  setTimeout(() => process.exit(143), 500).unref();
});

process.on("SIGINT", () => {
  log("SIGINT");
  setTimeout(() => process.exit(130), 500).unref();
});

process.on("uncaughtException", (error) => {
  log("uncaughtException", { error: safeError(error) });
  setTimeout(() => process.exit(1), 500).unref();
});

process.on("unhandledRejection", (reason) => {
  log("unhandledRejection", { error: safeError(reason) });
});
