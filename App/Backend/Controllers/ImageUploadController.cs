using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static System.Net.Mime.MediaTypeNames;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ImageUploadController : ControllerBase
    {
        public static IWebHostEnvironment _environment;

        public ImageUploadController(IWebHostEnvironment environment)
        {
            _environment = environment;
        }

        public class FileUploadApi
        {
            public IFormFile files { get; set; }
        }

        [HttpPost]
        public async Task<string> Post([FromForm]FileUploadApi objFile)
        {
            string path = "Upload/Post/";
            try
            {
                if (objFile.files.Length > 0)
                {
                    /*
                    if (!Directory.Exists(_environment.WebRootPath + "\\Upload\\Post\\"))
                    {
                        Directory.CreateDirectory(_environment.WebRootPath + "\\Upload\\Post\\");
                    }*/
                    using (FileStream fileStream = System.IO.File.Create($"{_environment.ContentRootPath}/wwwroot/" + path + objFile.files.FileName))
                    {
                        objFile.files.CopyTo(fileStream);
                        fileStream.Flush();
                        return path + objFile.files.FileName;

                    }
                }
                else
                {
                    return "Failed";
                }

            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }

        }

        [HttpPost("ProfilePhoto")]
        public async Task<string> PostProfilePhoto([FromForm]FileUploadApi objFile)
        {
            string path = "Upload/ProfilePhoto/";
            try
            {
                if (objFile.files.Length > 0)
                {
                    /*
                    if (!Directory.Exists(_environment.WebRootPath + "\\Upload\\ProfilePhoto\\"))
                    {
                        Directory.CreateDirectory(_environment.WebRootPath + "\\Upload\\ProfilePhoto\\");
                    }*/
                    using (FileStream fileStream = System.IO.File.Create($"{_environment.ContentRootPath}/wwwroot/" + path + objFile.files.FileName))
                    {
                        objFile.files.CopyTo(fileStream);
                        fileStream.Flush();
                        return path + objFile.files.FileName;

                    }
                }
                else
                {
                    return "Failed";
                }

            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }

        }

        [Route("test")]
        [HttpPost]
        public async Task<string> Test(WebImage webImage)
        {
           
            if (webImage.img != null || webImage.img != "")
            {
                byte[] bytes = Convert.FromBase64String(webImage.img);
                //var ext = "img";
                //var fullpath = Constant.ImagesRoot + DateTime.Now.ToString("yyyyMMddHHmmssfff") + "." + ext; 
                var path = "Upload//InstitutionProfilePhoto//" + Guid.NewGuid() + ".jpg";
                var filePath = Path.Combine($"{_environment.ContentRootPath}/wwwroot/" + path);
                System.IO.File.WriteAllBytes(filePath, bytes);
                return path;
            }

            return "";

        }

        [Route("WebSolution")]
        [HttpPost]
        public async Task<string> WebPost(WebImage webImage)
        {

            if (webImage.img != null || webImage.img != "")
            {
                byte[] bytes = Convert.FromBase64String(webImage.img);
                //var ext = "img";
                //var fullpath = Constant.ImagesRoot + DateTime.Now.ToString("yyyyMMddHHmmssfff") + "." + ext; 
                var path = "Upload//Post//" + Guid.NewGuid() + ".jpg";
                var filePath = Path.Combine($"{_environment.ContentRootPath}/wwwroot/" + path);
                System.IO.File.WriteAllBytes(filePath, bytes);
                return path;
            }

            return "";

        }
    }
}