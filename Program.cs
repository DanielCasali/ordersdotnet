using CustomerOrdersApi.Config;
using MongoDB.Bson.Serialization.Conventions;

namespace CustomerOrdersApi
{
  public class Program
  {
    public static void Main(string[] args)
    {
      var builder = WebApplication.CreateBuilder(args);

      var env = builder.Environment;

      builder.Configuration
        .SetBasePath(env.ContentRootPath)
        .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
        .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
        .AddEnvironmentVariables();

      var pack = new ConventionPack();
      pack.Add(new CamelCaseElementNameConvention());
      ConventionRegistry.Register("camel case", pack, t => true);

      // Add services to the container.

      builder.Services
        .Configure<AppSettings>(builder.Configuration)
        .AddControllers()
                  /*
                            .AddMvcOptions(c =>
                            {
                              c.EnableEndpointRouting = false;
                              c.OutputFormatters.Add(new JsonHalOutputFormatter(
                                  new Newtonsoft.Json.JsonSerializerSettings(),
                                  halJsonMediaTypes: new string[] { "application/hal+json", "application/vnd.example.hal+json", "application/vnd.example.hal.v1+json" }
                              ));
                            })*/
                  ;

      var app = builder.Build();

      // Configure the HTTP request pipeline.

      //app.UseHttpsRedirection();

      //app.UseAuthorization();

      app.MapControllers();

      if (env.IsDevelopment())
      {
        app.UseDeveloperExceptionPage();
      }

      app.Run();
    }
  }
}