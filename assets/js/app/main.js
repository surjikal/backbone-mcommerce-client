(function() {
  var HandlebarsHelpers;

  App.events.on('ready', function() {
    var fn, name;
    console.debug('Initializing main.');
    if (App.isPhonegap) {
      window.onerror = function(error) {
        return console.error(error);
      };
    }
    _.mixin({
      objMap: function(input, mapper, context) {
        var cb;
        cb = function(obj, v, k) {
          obj[k] = mapper.call(context, v, k, input);
          return obj;
        };
        return _.reduce(input, cb, {}, context);
      }
    });
    Backbone.LayoutManager.configure({
      fetch: function(name) {
        return App.templates[name];
      },
      render: function(template, context) {
        return this.el = template(_.extend({}, context, {
          isPhonegap: App.isPhonegap,
          Modernizr: Modernizr
        }));
      },
      deferred: _.Deferred,
      when: _.when,
      contains: function(a, b) {
        var adown, bup;
        adown = a.nodeType === 9 ? a.documentElement : bup = b && b.parentNode;
        return a === bup || !!(bup && bup.nodeType === 1 && adown.contains && adown.contains(bup));
      }
    });
    Backbone.View.prototype.close = function() {
      console.info("Closing view " + this);
      if (this.beforeClose) {
        this.beforeClose();
      }
      this.remove();
      return this.unbind();
    };
    new FastClick(document.body);
    for (name in HandlebarsHelpers) {
      fn = HandlebarsHelpers[name];
      Handlebars.registerHelper(name, fn);
    }
    App.initialize();
    Backbone.history.start({
      pushState: !App.isPhonegap,
      root: App.config.urls.root
    });
    return $(document).on('click', 'a[href]:not([data-bypass])', function(event) {
      var href, root;
      href = {
        prop: $(this).prop('href'),
        attr: $(this).attr('href')
      };
      root = "" + App.location + App.config.urls.root;
      if (href.prop.slice(0, (root.length - 1) + 1 || 9e9) === root) {
        event.preventDefault();
        return Backbone.history.navigate(href.attr, true);
      }
    });
  });

  HandlebarsHelpers = {
    formatPrice: function(price, decimalPlaces) {
      price = parseFloat(price);
      if (!_.isNumber(decimalPlaces)) {
        decimalPlaces = 2;
      }
      return (new Number(price)).toFixed(decimalPlaces);
    }
  };

}).call(this);
