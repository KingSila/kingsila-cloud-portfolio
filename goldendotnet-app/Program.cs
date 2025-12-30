using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;

var builder = WebApplication.CreateBuilder(args);

// Application Insights (make it loud)
builder.Services.AddApplicationInsightsTelemetry(options =>
{
    options.EnableAdaptiveSampling = false;   // IMPORTANT: don't drop events
    options.EnableDebugLogger = true;         // Writes AI SDK internal logs to app logs
});

var app = builder.Build();

app.Logger.LogWarning(
    "AI_CONNSTR={conn}",
    Environment.GetEnvironmentVariable("APPLICATIONINSIGHTS_CONNECTION_STRING")
);

app.MapGet("/", () =>
{
    app.Logger.LogInformation("Hello from golden-app test endpoint");
    return "Hello from golden-app with App Insights 👋";
});

app.MapGet("/health", () => Results.Ok("Healthy"));

// Proof endpoint (force send + wait)
app.MapGet("/telemetry", async (TelemetryClient telemetry, ILogger<Program> logger) =>
{
    logger.LogInformation("Telemetry endpoint hit");

    telemetry.TrackTrace("telemetry-trace: hello from golden-app");
    telemetry.TrackEvent("telemetry-event: golden-app");
    telemetry.Flush();

    // IMPORTANT: give the channel time to send before request ends
    await Task.Delay(5000);

    return Results.Ok("Telemetry sent");
});

app.Run();
