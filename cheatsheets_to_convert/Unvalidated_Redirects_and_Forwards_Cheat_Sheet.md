---
title: Unvalidated Redirects and Forwards Cheat Sheet
permalink: /Unvalidated_Redirects_and_Forwards_Cheat_Sheet/
---

`__NOTOC__`

<div style="width:100%;height:160px;border:0,margin:0;overflow: hidden;">
[link=](/File:Cheatsheets-header.jpg\ "wikilink")

</div>
{\\| style="padding: 0;margin:0;margin-top:10px;text-align:left;" \\|- \\| valign="top" style="border-right: 1px dotted gray;padding-right:25px;" \\| Last revision (mm/dd/yy): **//**

Introduction
============

`__TOC__`

Unvalidated redirects and forwards are possible when a web application accepts untrusted input that could cause the web application to redirect the request to a URL contained within untrusted input. By modifying untrusted URL input to a malicious site, an attacker may successfully launch a phishing scam and steal user credentials. Because the server name in the modified link is identical to the original site, phishing attempts may have a more trustworthy appearance. Unvalidated redirect and forward attacks can also be used to maliciously craft a URL that would pass the application’s access control check and then forward the attacker to privileged functions that they would normally not be able to access.

Safe URL Redirects
==================

When we want to redirect a user automatically to another page (without an action of the visitor such as clicking on a hyperlink) you might implement a code such as the following:

Java

` response.sendRedirect("`[`http://www.mysite.com`](http://www.mysite.com)`");`

PHP

` <?php`
` /* Redirect browser */`
` header("Location: `[`http://www.mysite.com/`](http://www.mysite.com/)`");`
` ?>`

ASP.NET

`  Response.Redirect("~/folder/Login.aspx")`

Rails

`   redirect_to login_path`

In the examples above, the URL is being explicitly declared in the code and cannot be manipulated by an attacker.

Dangerous URL Redirects
=======================

The following examples demonstrate unsafe redirect and forward code.

Dangerous URL Redirect Example 1
--------------------------------

The following Java code receives the URL from the 'url' GET parameter and redirects to that URL.

` response.sendRedirect(request.getParameter("url"));`

The following PHP code obtains a URL from the query string and then redirects the user to that URL.

` $redirect_url = $_GET['url'];`
` header("Location: " . $redirect_url);`
` `

A similar example of C\# .NET Vulnerable Code:

` string url = request.QueryString["url"];`
` Response.Redirect(url);`

And in rails:

`  redirect_to params[:url]`

The above code is vulnerable to an attack if no validation or extra method controls are applied to verify the certainty of the URL. This vulnerability could be used as part of a phishing scam by redirecting users to a malicious site. If no validation is applied, a malicious user could create a hyperlink to redirect your users to an unvalidated malicious website, for example:

` `[`http://example.com/example.php?url=http://malicious.example.com`](http://example.com/example.php?url=http://malicious.example.com)

The user sees the link directing to the original trusted site (example.com) and does not realize the redirection that could take place

Dangerous URL Redirect Example 2
--------------------------------

ASP.NET MVC 1 & 2 websites are particularly vulnerable to open redirection attacks. In order to avoid this vulnerability, you need to apply MVC 3.

The code for the LogOn action in an ASP.NET MVC 2 application is shown below. After a successful login, the controller returns a redirect to the returnUrl. You can see that no validation is being performed against the returnUrl parameter.

Listing 1 – ASP.NET MVC 2 LogOn action in AccountController.cs

` [HttpPost]`
` public ActionResult LogOn(LogOnModel model, string returnUrl)`
` {`
`   if (ModelState.IsValid)`
`   {`
`     if (MembershipService.ValidateUser(model.UserName, model.Password))`
`     {`
`       FormsService.SignIn(model.UserName, model.RememberMe);`
`       if (!String.IsNullOrEmpty(returnUrl))`
`       {`
`         return Redirect(returnUrl);`
`       }`
`       else`
`       {`
`         return RedirectToAction("Index", "Home");`
`       }`
`     }`
`     else`
`     {`
`       ModelState.AddModelError("", "The user name or password provided is incorrect.");`
`     }`
`   }`
`   // If we got this far, something failed, redisplay form`
`   return View(model);`
` }`

Dangerous Forward Example
-------------------------

When applications allow user input to forward requests between different parts of the site, the application must check that the user is authorized to access the url, perform the functions it provides, and it is an appropriate url request. If the application fails to perform these checks, an attacker crafted URL may pass the application’s access control check and then forward the attacker to an administrative function that is not normally permitted.

<http://www.example.com/function.jsp?fwd=admin.jsp>

The following code is a Java servlet that will receive a GET request with a url parameter in the request to forward to the address specified in the url parameter. The servlet will retrieve the url parameter value from the request and complete the server-side forward processing before responding to the browser.

`public class ForwardServlet extends HttpServlet `
`{`
`  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {`
`    String query = request.getQueryString();`
`    if (query.contains("fwd")) `
`    {`
`      String fwd = request.getParameter("fwd");`
`      try `
`      {`
`        request.getRequestDispatcher(fwd).forward(request, response);`
`      } `
`      catch (ServletException e) `
`      {`
`        e.printStackTrace();`
`      }`
`    }`
`  }`
`}`

Preventing Unvalidated Redirects and Forwards
=============================================

Safe use of redirects and forwards can be done in a number of ways:

-   Simply avoid using redirects and forwards.
-   If used, do not allow the url as user input for the destination. This can usually be done. In this case, you should have a method to validate URL.
-   If user input can’t be avoided, ensure that the supplied <strong>value</strong> is valid, appropriate for the application, and is <strong>authorized</strong> for the user.
-   It is recommended that any such destination input be mapped to a value, rather than the actual URL or portion of the URL, and that server side code translate this value to the target URL.
-   Sanitize input by creating a list of trusted URL's (lists of hosts or a regex).
-   Force all redirects to first go through a page notifying users that they are going off of your site, and have them click a link to confirm.

References
==========

1.  CWE Entry 601 on Open Redirects <http://cwe.mitre.org/data/definitions/601.html>
2.  WASC Article on URL Redirector Abuse <http://projects.webappsec.org/w/page/13246981/URL%20Redirector%20Abuse>
3.  Google blog article on the dangers of open redirects <http://googlewebmastercentral.blogspot.com/2009/01/open-redirect-urls-is-your-site-being.html>
4.  Preventing Open Redirection Attacks (C\#) <http://www.asp.net/mvc/tutorials/security/preventing-open-redirection-attacks>

Authors and Primary Editors
===========================

Susanna Bezold - susanna.bezold\[at\]owasp.org
Johanna Curiel - johanna.curiel\[at\]owasp.org
Jim Manico - jim\[at\]owasp.org

Other Cheatsheets
-----------------

\\|}

[Category:Cheatsheets](/Category:Cheatsheets "wikilink")