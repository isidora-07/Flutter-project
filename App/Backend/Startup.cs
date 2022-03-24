using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System.Security.Claims;
using Backend.Helpers;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Backend.UI;
using Backend.UI.Interfaces;
using Backend.BL;
using Backend.BL.Interfaces;
using Backend.DAL;
using Backend.DAL.Interfaces;
using Backend.Models;

namespace Backend
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            
            services.AddCors(options =>
            {
                options.AddPolicy("CorsPolicy", builder =>
                {
                    builder.AllowAnyOrigin()
                    .AllowAnyMethod()
                    .AllowAnyHeader();
                }
                );

            }

            );
            

            services.AddControllers().AddNewtonsoftJson(options =>
                options.SerializerSettings.ReferenceLoopHandling=Newtonsoft.Json.ReferenceLoopHandling.Ignore
                 
            );
            

            var appSettingsSection = Configuration.GetSection("AppSettings");
            services.Configure<AppSettings>(appSettingsSection);
            var appSettings = appSettingsSection.Get<AppSettings>();
            var key = Encoding.ASCII.GetBytes(appSettings.Secret);
            services.AddAuthentication(x =>
            {
                x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(x =>
            {
                x.RequireHttpsMetadata = false;
                x.SaveToken = true;
                x.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    ClockSkew = TimeSpan.Zero
                };

                x.Events = new JwtBearerEvents
                {
                    OnMessageReceived = context =>
                    {
                        var accessToken = context.Request.Query["access_token"];
                        if (string.IsNullOrEmpty(accessToken) == false)
                        {
                            context.Token = accessToken;
                        }
                        return Task.CompletedTask;
                    }
                };
            });

            services.AddDbContext<AppDbContext>();
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Latest);
            services.AddSignalR();

            services.AddTransient<IUserUI, UserUI>();
            services.AddTransient<IUserBL, UserBL>();
            services.AddTransient<IUserDAL, UserDAL>();

            services.AddTransient<ICityUI, CityUI>();
            services.AddTransient<ICityBL, CityBL>();
            services.AddTransient<ICityDAL, CityDAL>();

            services.AddTransient<ICommentUI, CommentUI>();
            services.AddTransient<ICommentBL, CommentBL>();
            services.AddTransient<ICommentDAL, CommentDAL>();

            services.AddTransient<IPostUI, PostUI>();
            services.AddTransient<IPostBL, PostBL>();
            services.AddTransient<IPostDAL, PostDAL>();

            services.AddTransient<ILikeUI, LikeUI>();
            services.AddTransient<ILikeBL, LikeBL>();
            services.AddTransient<ILikeDAL, LikeDAL>();

            services.AddTransient<IPostTypeUI, PostTypeUI>();
            services.AddTransient<IPostTypeBL, PostTypeBL>();
            services.AddTransient<IPostTypeDAL, PostTypeDAL>();

            services.AddTransient<IReportUI, ReportUI>();
            services.AddTransient<IReportBL, ReportBL>();
            services.AddTransient<IReportDAL, ReportDAL>();

            services.AddTransient<IReportCommentUI, ReportCommentUI>();
            services.AddTransient<IReportCommentBL, ReportCommentBL>();
            services.AddTransient<IReportCommentDAL, ReportCommentDAL>();

            services.AddTransient<IBlockedUsersUI, BlockedUsersUI>();
            services.AddTransient<IBlockedUsersBL, BlockedUsersBL>();
            services.AddTransient<IBlockedUsersDAL, BlockedUsersDAL>();

            services.AddTransient<IAdminUI, AdminUI>();
            services.AddTransient<IAdminBL, AdminBL>();
            services.AddTransient<IAdminDAL, AdminDAL>();

            services.AddTransient<IReportTypeUI, ReportTypeUI>();
            services.AddTransient<IReportTypeBL, ReportTypeBL>();
            services.AddTransient<IReportTypeDAL, ReportTypeDAL>();

            services.AddTransient<IInstitutionUI, InstitutionUI>();
            services.AddTransient<IInstitutionBL, InstitutionBL>();
            services.AddTransient<IInstitutionDAL, InstitutionDAL>();

            services.AddTransient<IEventUI, EventUI>();
            services.AddTransient<IEventBL, EventBL>();
            services.AddTransient<IEventDAL, EventDAL>();

            services.AddTransient<IDonationUI, DonationUI>();
            services.AddTransient<IDonationBL, DonationBL>();
            services.AddTransient<IDonationDAL, DonationDAL>();

            services.AddTransient<IChallengeSolvingUI, ChallengeSolvingUI>();
            services.AddTransient<IChallengeSolvingBL, ChallengeSolvingBL>();
            services.AddTransient<IChallengeSolvingDAL, ChallengeSolvingDAL>();

            services.AddTransient<IStatisticsUI, StatisticsUI>();
            services.AddTransient<IStatisticsBL, StatisticsBL>();
            services.AddTransient<IStatisticsDAL, StatisticsDAL>();

            services.AddTransient<IDisplayNotificationsUI, DisplayNotificationsUI>();
            services.AddTransient<IDisplayNotificationsBL, DisplayNotificationsBL>();
            services.AddTransient<IDisplayNotificationsDAL, DisplayNotificationsDAL>();


        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseCors("CorsPolicy");

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseStaticFiles();

            app.UseAuthentication();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
            //ChatHub
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapHub<ChatHub>("/notification");
            });
        }
    }
}
