using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using NetCandyStore.Models;

namespace NetCandyStore.Controllers
{
    public class SearchController : Controller
    {
        private CandiesDBEntities db = new CandiesDBEntities();

        // GET: Search
        public ActionResult Index()
        {
            return View(db.Products.ToList());
        }

        public ActionResult SearchByKeyword(FormCollection f)
        {
            string searchTerm = f["searchTerm"];
            if (string.IsNullOrEmpty(searchTerm))
                {
                return Redirect(HttpContext.Request.UrlReferrer.AbsoluteUri); 
            };
            ViewBag.SearchTerm = searchTerm;
            List<GetProductsBySearch_Result> r = db.GetProductsBySearch(searchTerm).ToList();
            return View(r);
        }
        public ActionResult SearchByCategory(int? categoryId=1)
        {
            // Get list matchng search
            List<GetProductsByCategoryId_Result> r = db.GetProductsByCategoryId(categoryId).ToList();

            // Get Category Description
            ViewBag.CategoryDescription = db.ProductCategories.FirstOrDefault(c => c.Id == categoryId).displayName;

            // Return results to View
            return View(r);
        }
        // GET: Search/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.Products.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }
            return View(product);
        }

        // GET: Search/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Search/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,isActive,displayName,description,itemPrice,itemPackageType,quantityPerPackage,keywords,imageURL")] Product product)
        {
            if (ModelState.IsValid)
            {
                db.Products.Add(product);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(product);
        }

        // GET: Search/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.Products.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }
            return View(product);
        }

        // POST: Search/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,isActive,displayName,description,itemPrice,itemPackageType,quantityPerPackage,keywords,imageURL")] Product product)
        {
            if (ModelState.IsValid)
            {
                db.Entry(product).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(product);
        }

        // GET: Search/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.Products.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }
            return View(product);
        }

        // POST: Search/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Product product = db.Products.Find(id);
            db.Products.Remove(product);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
