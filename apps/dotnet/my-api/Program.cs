using Azure.Messaging.ServiceBus;
using my_api.Hubs;

Console.WriteLine($"init...");

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSignalR();

var app = builder.Build();

app.MapHub<NotificationsHub>("/signalr/notifications");
app.MapGet("/", () => "Hello World!");


var sbClient = new ServiceBusClient(builder.Configuration.GetConnectionString("ServiceBus"),
         new ServiceBusClientOptions()
         {
             TransportType = ServiceBusTransportType.AmqpWebSockets
         });

var topic = "payments";
var subscription = "orders";
var serviceBusProcessor = sbClient.CreateProcessor(topic, subscription, new ServiceBusProcessorOptions());

serviceBusProcessor.ProcessMessageAsync += async (args) =>
{
    var body = args.Message.Body.ToString();
    Console.WriteLine($"Received: {body}");
    await args.CompleteMessageAsync(args.Message);
};

serviceBusProcessor.ProcessErrorAsync += async (err) =>
{
    System.Console.WriteLine($"ServiceBus Error: {err.Exception.Message}");
};

System.Console.WriteLine("starting message processor...");

await serviceBusProcessor.StartProcessingAsync();

Console.WriteLine($"app.run...");

app.Run();
