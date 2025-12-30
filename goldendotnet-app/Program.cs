using Microsoft.ApplicationInsights.Extensibility;

var builder = WebApplication.CreateBuilder(args);

// Add Application Insights
builder.Services.AddApplicationInsightsTelemetry();

var app = builder.Build();
app.Logger.LogWarning("AI_CONNSTR={conn}", Environment.GetEnvironmentVariable("APPLICATIONINSIGHTS_CONNECTION_STRING"));


app.MapGet("/", () =>
{
    app.Logger.LogInformation("Hello from golden-app test endpoint");
    return "Hello from golden-app with App Insights 👋";
});

app.MapGet("/health", () => Results.Ok("Healthy"));

app.Run();
