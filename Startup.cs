using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(NetCandyStore.Startup))]
namespace NetCandyStore
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
