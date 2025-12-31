using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Extensions.Logging;

var builder = WebApplication.CreateBuilder(args);

// ✅ Make App Insights SDK "talk" in container logs (high signal)
builder.Logging.AddFilter("Microsoft.ApplicationInsights", LogLevel.Trace);
builder.Logging.AddFilter("Microsoft.ApplicationInsights.Channel", LogLevel.Trace);
builder.Logging.AddFilter("Microsoft.ApplicationInsights.Extensibility", LogLevel.Trace);

// Pull connection string explicitly from env
var aiConnectionString =
    Environment.GetEnvironmentVariable("APPLICATIONINSIGHTS_CONNECTION_STRING");

// Fail fast if missing (saves hours of confusion)
if (string.IsNullOrWhiteSpace(aiConnectionString))
{
    throw new InvalidOperationException(
        "APPLICATIONINSIGHTS_CONNECTION_STRING is not set");
}

// Application Insights – explicit, loud, deterministic
builder.Services.AddApplicationInsightsTelemetry(options =>
{
    options.ConnectionString = aiConnectionString;

    // Do not sample while debugging
    options.EnableAdaptiveSampling = false;

    // Emit AI SDK internal diagnostics into app logs
    options.EnableDebugLogger = true;
});

var app = builder.Build();

// Log what the SDK actually sees at startup
var telemetryClient = app.Services.GetRequiredService<TelemetryClient>();
app.Logger.LogWarning(
    "AppInsights configured. IKey={ikey}",
    telemetryClient.TelemetryConfiguration.InstrumentationKey
);

// ✅ Optional: emit a startup trace + event to prove ingestion ASAP
telemetryClient.TrackTrace("startup: golden-app booted");
telemetryClient.TrackEvent("startup: golden-app");
telemetryClient.Flush();

// Basic endpoint
app.MapGet("/", (ILogger<Program> logger) =>
{
    logger.LogInformation("Root endpoint hit");
    return "Hello from golden-app with Application Insights 🚀";
});

// Health check
app.MapGet("/health", () => Results.Ok("Healthy"));

// Introspection endpoint (truth serum)
app.MapGet("/ai", () =>
{
    var cfg = telemetryClient.TelemetryConfiguration;
    return Results.Ok(new
    {
        cfg.ConnectionString,
        cfg.InstrumentationKey
    });
});

// Force-send telemetry endpoint
app.MapGet("/telemetry", async (ILogger<Program> logger) =>
{
    logger.LogInformation("Telemetry endpoint hit");

    telemetryClient.TrackTrace("trace: hello from golden-app");
    telemetryClient.TrackEvent("event: golden-app-test");

    telemetryClient.Flush();

    // Give the background channel time to ship data
    await Task.Delay(15000);

    return Results.Ok("Telemetry flushed");
});

app.Run();
