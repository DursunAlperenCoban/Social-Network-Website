using Microsoft.Extensions.DependencyInjection;
using Microsoft.Owin;
using Owin;


[assembly: OwinStartupAttribute(typeof(ParlanceNet.Startup))]

namespace ParlanceNet
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            app.MapSignalR();
        }
    }
}