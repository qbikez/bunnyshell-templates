Console.WriteLine($"init...");

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hello World!");

Console.WriteLine($"app.run...");

app.Run();
