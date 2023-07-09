using Azure.Messaging.ServiceBus;
using Microsoft.AspNetCore.SignalR;
using my_api.Hubs;
using Newtonsoft.Json;

Console.WriteLine($"init...");

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSignalR();

var app = builder.Build();

var orders = new Dictionary<string, Order>();

app.MapHub<NotificationsHub>("/signalr/notifications");
app.MapGet("/", () => "hello from order fullfilment service!");
app.MapGet("/orders", () =>
{
    return orders;
});


var sbClient = new ServiceBusClient(builder.Configuration.GetConnectionString("ServiceBus"),
         new ServiceBusClientOptions()
         {
             TransportType = ServiceBusTransportType.AmqpWebSockets
         });

var topic = "payments";
var subscription = "orders";
var serviceBusProcessor = sbClient.CreateProcessor(topic, subscription, new ServiceBusProcessorOptions());
var notificationsHub = app.Services.GetRequiredService<IHubContext<NotificationsHub>>();

serviceBusProcessor.ProcessMessageAsync += async (args) =>
{
    var body = args.Message.Body.ToString();
    Console.WriteLine($"Received: {body}");
    var command = args.Message.Body.ToObjectFromJson<CommandMessage>();

    if (command.command == "pay")
    {
        var order = command.order;
        Console.WriteLine($"processing order: {order.orderId} with status '{order.status}'");

        orders[order.orderId] = order;
        await notificationsHub.Clients.All.SendAsync("ReceiveMessage", body);
    }
    else if (command.command == "paymentComplete")
    {
        var order = command.order;
        Console.WriteLine($"marking order as '{order.status}': {order.orderId}");

        orders[order.orderId] = order;
        await notificationsHub.Clients.All.SendAsync("ReceiveMessage", body);
    } else {
        Console.WriteLine($"unknown command: {command.command}");
    }
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


public record Order(string orderId, string status);
public record CommandMessage(string command, Order order);
