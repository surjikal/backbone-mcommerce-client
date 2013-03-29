(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['address-create'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var foundHelper, self=this;


  return "<fieldset class=\"address-create\"><fieldset><label for=\"shipping-firstname\">Full Name</label><input id=\"shipping-firstname\" name=\"shipping[firstname]\" placeholder=\"First\" type=\"text\" value=\"Huge\"/><input id=\"shipping-lastname\" name=\"shipping[lastname]\" placeholder=\"Last\" type=\"text\" value=\"Ackman\"/></fieldset><label>Street Address<input id=\"shipping-street\" name=\"shipping[street]\" placeholder=\"123 Awesome Road\" type=\"text\" value=\"123 Trolley Road\"/></label><label>Postal/Zip Code<input id=\"shipping-postalcode\" name=\"shipping[postalcode]\" type=\"text\" placeholder=\"B4N 4N4\" autocapitalize=\"on\" value=\"10002\"/></label></fieldset>";});
templates['address-select'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var foundHelper, self=this;


  return "<div class=\"address-select\"></div>";});
templates['address'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  
  return "<i class=\"icon-checkmark active check\"></i>";}

function program3(depth0,data) {
  
  
  return "<i class=\"icon-checkmark check\"></i>";}

  buffer += "<div class=\"vcard\"><div class=\"n\"><span class=\"given-name\">";
  foundHelper = helpers.firstName;
  stack1 = foundHelper || depth0.firstName;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "firstName", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span><span class=\"family-name\"> ";
  foundHelper = helpers.lastName;
  stack1 = foundHelper || depth0.lastName;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "lastName", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span></div><p class=\"adr\"><span class=\"street\">";
  foundHelper = helpers.street;
  stack1 = foundHelper || depth0.street;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "street", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span><br/><span class=\"postal-code\">";
  foundHelper = helpers.postalCode;
  stack1 = foundHelper || depth0.postalCode;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "postalCode", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span></p></div>";
  foundHelper = helpers.selected;
  stack1 = foundHelper || depth0.selected;
  stack2 = helpers['if'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.program(3, program3, data);
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "<span style=\"display: none;\" class=\"remove label label-important\">remove</span>";
  return buffer;});
templates['auth-login'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "<label>Email Address<input id=\"user-email\" type=\"email\" name=\"email\" required=\"required\" //-=\"//-\" placeholder=\"bob@example.com\" value=\"";
  foundHelper = helpers.email;
  stack1 = foundHelper || depth0.email;
  stack2 = helpers['if'];
  tmp1 = self.program(2, program2, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"/></label>";
  return buffer;}
function program2(depth0,data) {
  
  var stack1;
  foundHelper = helpers.email;
  stack1 = foundHelper || depth0.email;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "email", { hash: {} }); }
  return escapeExpression(stack1);}

  buffer += "<form method=\"post\" action=\".\"><div class=\"instructions section\">";
  foundHelper = helpers.instructions;
  stack1 = foundHelper || depth0.instructions;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "instructions", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</div><fieldset class=\"section\">";
  foundHelper = helpers.user;
  stack1 = foundHelper || depth0.user;
  stack2 = helpers['with'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "<div class=\"password-widget\"></div></fieldset><button id=\"login-button\" type=\"submit\" disabled=\"disabled\" class=\"button-primary\">";
  foundHelper = helpers.buttonText;
  stack1 = foundHelper || depth0.buttonText;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "buttonText", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</button></form>";
  return buffer;});
templates['auth-register'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, foundHelper, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;


  buffer += "<form method=\"post\" action=\".\"><label for=\"user-email\" class=\"instructions\">What's your email address? We'll email you the receipt.</label><input id=\"user-email\" type=\"email\" name=\"email\" placeholder=\"Email Address\" value=\"";
  foundHelper = helpers.email;
  stack1 = foundHelper || depth0.email;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "email", { hash: {} }); }
  buffer += escapeExpression(stack1) + "\"/><br/><label for=\"user-password\" class=\"instructions\">Speed up your next checkout by saving your info! (optional)</label><div class=\"password-widget section\"></div><button id=\"register-button\" type=\"submit\" disabled=\"disabled\" class=\"button-primary\">Register</button></form>";
  return buffer;});
templates['billing-paypal'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var foundHelper, self=this;


  return "<div id=\"wizard-step-list\"></div><div id=\"wizard-status-bar\"><h1>Your order</h1><div class=\"order-table\"></div></div><div id=\"wizard-step\"><div style=\"margin-top: 1em\" class=\"instructions section\"><p>We use PayPal to ensure that your billing information is safe.</p><p>You will only be charged after you confirm your order.</p></div><button id=\"wizard-next-step\" type=\"submit\" class=\"button-primary\">Continue to PayPal</button></div>";});
templates['billing-stripe'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this;

function program1(depth0,data) {
  
  
  return "<button id=\"scan-card-button\" type=\"button\" style=\"margin-bottom: 1em\" class=\"btn button-primary\">Scan Your Card</button>";}

function program3(depth0,data) {
  
  
  return "<input id=\"billing-expiry\" type=\"tel\" placeholder=\"MM / YY\" maxlength=\"7\" required=\"required\" value=\"05 / 13\"/>";}

function program5(depth0,data) {
  
  
  return "<input id=\"billing-expiry\" type=\"tel\" placeholder=\"MM / YY\" maxlength=\"7\" required=\"required\" value=\"05 / 13\"/>";}

  buffer += "<div id=\"wizard-step-list\"></div><div id=\"wizard-status-bar\">Your total will be shown on the next page.</div><div id=\"wizard-step\"><form id=\"stripe-form\" method=\"post\" action=\".\" style=\"margin-top: 0.8em\"><fieldset style=\"overflow: hidden; margin-bottom: 0.6em\">";
  foundHelper = helpers.isPhonegap;
  stack1 = foundHelper || depth0.isPhonegap;
  stack2 = helpers['if'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "<label class=\"card-number\">Credit Card Number<input id=\"billing-card-number\" type=\"tel\" placeholder=\"Card Number\" required=\"required\" maxlength=\"18\" value=\"4242 4242 4242 4242\" class=\"visa\"/></label><label class=\"expiry-date\">Expiry Date\n";
  foundHelper = helpers.Modernizr;
  stack1 = foundHelper || depth0.Modernizr;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.inputtypes);
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.month);
  stack2 = helpers['if'];
  tmp1 = self.program(3, program3, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.program(5, program5, data);
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</label><label class=\"cvc\">CVC<input id=\"billing-cvc\" type=\"tel\" placeholder=\"123\" maxlength=\"4\" required=\"required\" value=\"123\"/></label></fieldset><button id=\"wizard-next-step\" type=\"submit\" disabled=\"disabled\" class=\"button-primary\">Fill in all fields</button></form></div>";
  return buffer;});
templates['billing'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", foundHelper, self=this;


  return buffer;});
templates['boutique-select'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this;

function program1(depth0,data) {
  
  
  return "<div class=\"instructions\">Scan an item or enter a boutique code to begin!</div>";}

function program3(depth0,data) {
  
  
  return "<div class=\"instructions\">Enter a boutique code to begin!</div>";}

function program5(depth0,data) {
  
  
  return "<div style=\"color: #aaa; padding: 1em 0; clear: both; text-shadow: 0px 1px 0px white\" class=\"sep\">or</div><div class=\"anti-button-flicker loading\"><button id=\"scan-button\" type=\"button\" class=\"button-primary\">Scan Item</button></div>";}

  buffer += "<h1 class=\"logo\">trolley</h1><hr/><form id=\"boutique-select-form\" method=\"post\" action=\".\">";
  foundHelper = helpers.isPhonegap;
  stack1 = foundHelper || depth0.isPhonegap;
  stack2 = helpers['if'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.program(3, program3, data);
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "<input id=\"boutique-code\" name=\"boutique-code\" type=\"text\" autocapitalize=\"off\" autocorrect=\"off\" value=\"trolley\" class=\"input-no-focus-left-border\"/><button id=\"navigate-to-boutique-button\" type=\"submit\" class=\"button-primary\">Visit Boutique</button>";
  foundHelper = helpers.isPhonegap;
  stack1 = foundHelper || depth0.isPhonegap;
  stack2 = helpers['if'];
  tmp1 = self.program(5, program5, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</form>";
  return buffer;});
templates['boutique'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "<div class=\"table-row\">";
  foundHelper = helpers.itemSpots;
  stack1 = foundHelper || depth0.itemSpots;
  stack2 = helpers.each;
  tmp1 = self.program(2, program2, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</div>";
  return buffer;}
function program2(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "<li><div class=\"itemspot\"><a href=\"";
  foundHelper = helpers.url;
  stack1 = foundHelper || depth0.url;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "url", { hash: {} }); }
  buffer += escapeExpression(stack1) + "\" style=\"background-image: url(";
  foundHelper = helpers.image;
  stack1 = foundHelper || depth0.image;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "image", { hash: {} }); }
  buffer += escapeExpression(stack1) + ");\" class=\"image\"></a><footer><div class=\"bottom-bar\"><div class=\"item-name\">";
  foundHelper = helpers.item;
  stack1 = foundHelper || depth0.item;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.name);
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "item.name", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</div><div class=\"price\"><span class=\"dollar\"></span>";
  foundHelper = helpers.itemPrice;
  stack1 = foundHelper || depth0.itemPrice;
  foundHelper = helpers.formatPrice;
  stack2 = foundHelper || depth0.formatPrice;
  if(typeof stack2 === functionType) { stack1 = stack2.call(depth0, stack1, { hash: {} }); }
  else if(stack2=== undef) { stack1 = helperMissing.call(depth0, "formatPrice", stack1, { hash: {} }); }
  else { stack1 = stack2; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</div></div></footer></div></li>";
  return buffer;}

  buffer += "<ul class=\"items\">";
  foundHelper = helpers.itemSpotRow;
  stack1 = foundHelper || depth0.itemSpotRow;
  stack2 = helpers.each;
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</ul>";
  return buffer;});
templates['confirm'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var foundHelper, self=this;


  return "<div id=\"wizard-step-list\"></div><div id=\"wizard-status-bar\"><h1>Your order</h1><div class=\"order-table\"></div></div><div id=\"wizard-step\"><div class=\"section\"></div><form id=\"confirm-form\" method=\"post\" action=\".\"><button id=\"wizard-next-step\" type=\"submit\" class=\"button-primary\">Confirm your order</button></form></div>";});
templates['header'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var foundHelper, self=this;


  return "<div class=\"navigation-bar\"><div class=\"restrict-width\"><h1 class=\"logo\">trolley</h1><a class=\"action left-action back\"><i class=\"icon-back\"></i></a><a class=\"action right-action open-menu\"><i class=\"icon-list\"></i></a></div><div class=\"restrict-width\"><div class=\"menu\"></div></div></div>";});
templates['itemspot'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var stack1;
  foundHelper = helpers.itemQuantity;
  stack1 = foundHelper || depth0.itemQuantity;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "itemQuantity", { hash: {} }); }
  return escapeExpression(stack1);}

function program3(depth0,data) {
  
  
  return "1";}

  buffer += "<section class=\"item-images\"><div class=\"carousel\"><img src=\"";
  foundHelper = helpers.image;
  stack1 = foundHelper || depth0.image;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "image", { hash: {} }); }
  buffer += escapeExpression(stack1) + "\"/></div></section><section class=\"item-info\"><header class=\"waypoint\"><section class=\"item-top-bar\"><h1 class=\"item-name\">";
  foundHelper = helpers.item;
  stack1 = foundHelper || depth0.item;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.name);
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "item.name", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</h1></section><section class=\"item-action-bar\"><div class=\"action action-left\"><span class=\"item-quantity\">";
  foundHelper = helpers.itemQuantity;
  stack1 = foundHelper || depth0.itemQuantity;
  stack2 = helpers['if'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.program(3, program3, data);
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</span><span class=\"item-price\">";
  foundHelper = helpers.itemPrice;
  stack1 = foundHelper || depth0.itemPrice;
  foundHelper = helpers.formatPrice;
  stack2 = foundHelper || depth0.formatPrice;
  if(typeof stack2 === functionType) { stack1 = stack2.call(depth0, stack1, { hash: {} }); }
  else if(stack2=== undef) { stack1 = helperMissing.call(depth0, "formatPrice", stack1, { hash: {} }); }
  else { stack1 = stack2; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</span></div><div class=\"action action-right\"><button id=\"buy-button\" type=\"button\" class=\"button-primary\">Purchase</button></div></section></header><div class=\"item-details\"><p>";
  foundHelper = helpers.item;
  stack1 = foundHelper || depth0.item;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.details);
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "item.details", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</p></div></section>";
  return buffer;});
templates['login-or-new-user'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var foundHelper, self=this;


  return "<fieldset><button id=\"new-user-button\" type=\"button\" class=\"button-primary section\">First Time Customer</button><button id=\"existing-user-button\" type=\"button\" class=\"button-primary\">Returning Customer</button></fieldset>";});
templates['menu-list-item'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<a href=\"";
  foundHelper = helpers.url;
  stack1 = foundHelper || depth0.url;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "url", { hash: {} }); }
  buffer += escapeExpression(stack1) + "\">";
  foundHelper = helpers.title;
  stack1 = foundHelper || depth0.title;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "title", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</a>";
  return buffer;}

function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<span>";
  foundHelper = helpers.title;
  stack1 = foundHelper || depth0.title;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "title", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span>";
  return buffer;}

  foundHelper = helpers.url;
  stack1 = foundHelper || depth0.url;
  stack2 = helpers['if'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.program(3, program3, data);
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }});
templates['order-table'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;


  buffer += "<table class=\"item\"><tr><td><span class=\"item-quantity\">1</span><span class=\"times\">×</span><span class=\"item-name\">";
  foundHelper = helpers.item;
  stack1 = foundHelper || depth0.item;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.name);
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "item.name", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span></td><td class=\"right-column\"><div class=\"price item-price right\">";
  foundHelper = helpers.costs;
  stack1 = foundHelper || depth0.costs;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.item);
  foundHelper = helpers.formatPrice;
  stack2 = foundHelper || depth0.formatPrice;
  if(typeof stack2 === functionType) { stack1 = stack2.call(depth0, stack1, { hash: {} }); }
  else if(stack2=== undef) { stack1 = helperMissing.call(depth0, "formatPrice", stack1, { hash: {} }); }
  else { stack1 = stack2; }
  buffer += escapeExpression(stack1) + "</div></td></tr></table><hr/><table class=\"costs\"><tr class=\"shipping\"><td>Shipping</td><td class=\"right-column price\">";
  foundHelper = helpers.costs;
  stack1 = foundHelper || depth0.costs;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.shipping);
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "costs.shipping", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</td></tr><tr class=\"tax\"><td>Tax</td><td class=\"right-column price\">";
  foundHelper = helpers.costs;
  stack1 = foundHelper || depth0.costs;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.tax);
  foundHelper = helpers.formatPrice;
  stack2 = foundHelper || depth0.formatPrice;
  if(typeof stack2 === functionType) { stack1 = stack2.call(depth0, stack1, { hash: {} }); }
  else if(stack2=== undef) { stack1 = helperMissing.call(depth0, "formatPrice", stack1, { hash: {} }); }
  else { stack1 = stack2; }
  buffer += escapeExpression(stack1) + "</td></tr><tr class=\"total\"><td>Total</td><td class=\"right-column price\">";
  foundHelper = helpers.costs;
  stack1 = foundHelper || depth0.costs;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.total);
  foundHelper = helpers.formatPrice;
  stack2 = foundHelper || depth0.formatPrice;
  if(typeof stack2 === functionType) { stack1 = stack2.call(depth0, stack1, { hash: {} }); }
  else if(stack2=== undef) { stack1 = helperMissing.call(depth0, "formatPrice", stack1, { hash: {} }); }
  else { stack1 = stack2; }
  buffer += escapeExpression(stack1) + "</td></tr></table>";
  return buffer;});
templates['password-widget'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var foundHelper, self=this;


  return "<input id=\"user-password\" type=\"password\" name=\"password\" autocomplete=\"off\" placeholder=\"Password\" value=\"JoinTrolley\" class=\"password hidden\"/><input id=\"user-password-clear\" type=\"text\" name=\"password-clear\" autocomplete=\"off\" placeholder=\"Password\" value=\"JoinTrolley\" class=\"password\"/><label for=\"toggle-password-display-checkbox\" class=\"toggle-password-display\"><input id=\"toggle-password-display-checkbox\" name=\"show-password\" type=\"checkbox\" checked=\"checked\"/>Show Password</label>";});
templates['popup'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<h1>";
  foundHelper = helpers.title;
  stack1 = foundHelper || depth0.title;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "title", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</h1>";
  return buffer;}

function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<div class=\"instructions section\">";
  foundHelper = helpers.instructions;
  stack1 = foundHelper || depth0.instructions;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "instructions", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</div>";
  return buffer;}

  buffer += "<div class=\"dim-overlay\"></div><div class=\"popup\"><header><i class=\"close icon-cross\"></i></header>";
  foundHelper = helpers.title;
  stack1 = foundHelper || depth0.title;
  stack2 = helpers['if'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  foundHelper = helpers.instructions;
  stack1 = foundHelper || depth0.instructions;
  stack2 = helpers['if'];
  tmp1 = self.program(3, program3, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "<div class=\"contents\"></div></div>";
  return buffer;});
templates['shipping'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n";
  foundHelper = helpers.user;
  stack1 = foundHelper || depth0.user;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.email);
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "user.email", { hash: {} }); }
  buffer += escapeExpression(stack1) + "<a id=\"show-login-popup\">Not you?</a>";
  return buffer;}

function program3(depth0,data) {
  
  
  return "\nHave an account?<a id=\"show-login-popup\">Login</a>";}

function program5(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<button id=\"toggle-address-mode\" type=\"button\" class=\"button-secondary\">";
  foundHelper = helpers.toggleButtonText;
  stack1 = foundHelper || depth0.toggleButtonText;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "toggleButtonText", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</button>";
  return buffer;}

  buffer += "<div id=\"wizard-step-list\"></div><div id=\"wizard-status-bar\">";
  foundHelper = helpers.user;
  stack1 = foundHelper || depth0.user;
  stack2 = helpers['if'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.program(3, program3, data);
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</div><div id=\"wizard-step\"><header>";
  foundHelper = helpers.showModeToggleButton;
  stack1 = foundHelper || depth0.showModeToggleButton;
  stack2 = helpers['if'];
  tmp1 = self.program(5, program5, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "<h1>Shipping Address</h1></header><form id=\"shipping-info-form\" autocomplete=\"off\"><div id=\"address-mode\" class=\"section\"></div><button id=\"wizard-next-step\" type=\"submit\" disabled=\"disabled\" class=\"button-primary\">Fill in all fields</button></form></div>";
  return buffer;});
templates['thanks'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, foundHelper, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;


  buffer += "<header class=\"section\"><h1>Awesome! Your shipment will arrive soon!</h1><div class=\"item-name\">";
  foundHelper = helpers.itemspot;
  stack1 = foundHelper || depth0.itemspot;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.item);
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.name);
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "itemspot.item.name", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</div></header><div class=\"postit section\"><p>Thank you from<h2 style=\"font-family: 'FuturaFile';\">♥ trolley</h2></p></div><br/><br/><div class=\"section\"><button id=\"back-to-boutique\" type=\"submit\" class=\"button-primary\">Back to Boutique</button></div>";
  return buffer;});
templates['wizard-status-bar-auth'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n";
  foundHelper = helpers.user;
  stack1 = foundHelper || depth0.user;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.email);
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "user.email", { hash: {} }); }
  buffer += escapeExpression(stack1) + "<a id=\"show-login-popup\">Not you?</a>";
  return buffer;}

function program3(depth0,data) {
  
  
  return "\nHave an account?<a id=\"show-login-popup\">Login</a>";}

  foundHelper = helpers.user;
  stack1 = foundHelper || depth0.user;
  stack2 = helpers['if'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.program(3, program3, data);
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }});
templates['wizard-status-bar-order'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var foundHelper, self=this;


  return "<h1>Your order</h1><div class=\"order-table\"></div>";});
templates['wizard-step-list-item'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  
  return "<i class=\"icon-checkmark\"></i>";}

function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<em class=\"index\">";
  foundHelper = helpers.index;
  stack1 = foundHelper || depth0.index;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "index", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</em>";
  return buffer;}

  buffer += "<div class=\"step\">";
  foundHelper = helpers.completed;
  stack1 = foundHelper || depth0.completed;
  stack2 = helpers['if'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.program(3, program3, data);
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "<span class=\"title\">";
  foundHelper = helpers.title;
  stack1 = foundHelper || depth0.title;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "title", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span></div><div class=\"separator\"></div>";
  return buffer;});
templates['wizard-step'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var foundHelper, self=this;


  return "<div id=\"wizard-step-status-bar\"></div><div id=\"wizard-step-contents\"></div>";});
})();