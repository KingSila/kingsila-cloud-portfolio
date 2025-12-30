using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;

var builder = WebApplication.CreateBuilder(args);

// Add Application Insights
builder.Services.AddApplicationInsightsTelemetry();

var app = builder.Build();

// Log the connection string at startup (diagnostic)
app.Logger.LogWarning(
    "AI_CONNSTR={conn}",
    Environment.GetEnvironmentVariable("APPLICATIONINSIGHTS_CONNECTION_STRING")
);

// Normal endpoint
app.MapGet("/", () =>
{
    app.Logger.LogInformation("Hello from golden-app test endpoint");
    return "Hello from golden-app with App Insights 👋";
});

// Health endpoint
app.MapGet("/health", () => Results.Ok("Healthy"));

// 🔥 STEP 3: Telemetry proof endpoint
app.MapGet("/telemetry", (TelemetryClient telemetry, ILogger<Program> logger) =>
{
    logger.LogInformation("Telemetry endpoint hit");

    telemetry.TrackTrace("telemetry-trace: hello from golden-app");
    telemetry.TrackEvent("telemetry-event: golden-app");
    telemetry.Flush();

    return Results.Ok("Telemetry sent");
});

app.Run();
