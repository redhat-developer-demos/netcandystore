using NetCandyStore.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NetCandyStore.Controllers
{
    public class CartController : Controller
    {
        private CandiesDBEntities db = new CandiesDBEntities();
        // GET: Cart
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult BuyNow()
        {
            // Get cart
            // Get or Create Cart GUID
            string cartGUID;
            HttpCookie cartCookie = Request.Cookies["netcandystoreCartGUID"];
            if (cartCookie != null && cartCookie.Values["cartGUID"] != null)
            {
                cartGUID = cartCookie.Values["cartGUID"];
                db.CreateShoppingCart(cartGUID, 1);
                db.SaveChanges();
            }
            else
            {
                //Cookie not set.
                cartGUID = System.Guid.NewGuid().ToString();
                //create cookie 
                HttpCookie mycookie = new HttpCookie("netcandystore");
                mycookie.Values["cartGUID"] = cartGUID;
                Response.Cookies.Add(mycookie);

                db.CreateShoppingCart(cartGUID, 1);
                db.SaveChanges();
            }
            //db.CalculateCartTotal(cartGUID);
            var cart = db.GetShoppingCart(cartGUID);
            var items = db.GetShoppingCartItems(cartGUID);
            return View();
        }

        public ActionResult SubmitPayment()
        {
            // TODO Update Shopping Cart with payment information

            // Replace shopping cart cookie, i.e. start a new cart
            HttpCookie cartCookie = Request.Cookies["netcandystoreCartGUID"];
            string cartGUID = System.Guid.NewGuid().ToString();
            cartCookie.Values["cartGUID"] = cartGUID;
            cartCookie.Expires = DateTime.UtcNow.AddDays(30);
            Response.Cookies.Add(cartCookie);


            // TODO Navigate to Orders Summary screen
            return View();
        }
        public ActionResult Payment()
        {
            // TODO Get cart id
            string cartGUID;
            HttpCookie cartCookie = Request.Cookies["netcandystoreCartGUID"];
            cartGUID = cartCookie.Values["cartGUID"];
            // TODO Get cart contents

            // TODO Prompt for address and payment
            ShoppingCart sc = db.ShoppingCarts.Find(cartGUID);
            return View(sc);
        }
        public ActionResult AddToCart(int? Id = 1)
        {
            // Get or Create Cart GUID
            string cartGUID;
            HttpCookie cartCookie = Request.Cookies["netcandystoreCartGUID"];
            if (cartCookie != null && cartCookie.Values["cartGUID"] != null)
            {
                cartGUID = cartCookie.Values["cartGUID"];
            }
            else
            {
                //Cookie not set.
                cartGUID = System.Guid.NewGuid().ToString();
                //create cookie with some ID as i have given CookName
                cartCookie = new HttpCookie("netcandystoreCartGUID");
                cartCookie.Values["cartGUID"] = cartGUID;
                cartCookie.Expires = DateTime.Now.Add(TimeSpan.FromHours(200));
                Response.Cookies.Add(cartCookie);
            }

            // Get item
            Product thisProduct = db.Products.FirstOrDefault(p => p.Id == Id);
            // Get item so we have a price at the time of being added to cart
            decimal itemPrice = (decimal)thisProduct.itemPrice;

            // Set quantity
            int quantity = 1;

            // Set status to Active
            byte status = 1;

            // Add to cart
            db.AddToCart(cartGUID, Id, itemPrice, quantity, status);
            db.SaveChanges();
            //            List<GetProductsByCategoryId_Result> r = db.GetProductsByCategoryId(categoryId).ToList();

            // Get Shopping Cart items

            // Return cart contents to View
            return View("Index", db.GetShoppingCartItems(cartGUID).ToList());
        }
    }
}