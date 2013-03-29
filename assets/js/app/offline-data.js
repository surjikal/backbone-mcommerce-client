(function() {
  var OfflineApi, OfflineAuthApi, OfflineData, OfflinePurchaseApi,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  OfflineData = {
    user: {
      email: 'porter.nicolas@gmail.com',
      password: 'trolley',
      account: {
        addresses: [
          {
            city: "Ottawa",
            country: "canada",
            firstName: "Nick",
            lastName: "Porter",
            postalCode: "K4A 4H5",
            province: "ON",
            street: "1911 Venus Avenue"
          }, {
            city: "Toronto",
            country: "canada",
            firstName: "Justin",
            lastName: "Beiber",
            postalCode: "10019",
            province: "ON",
            street: "825 Eighth Avenue"
          }
        ],
        firstName: "Nick",
        lastName: "Porter"
      }
    },
    boutiques: [
      {
        code: "trolley",
        itemSpots: [
          {
            itemPrice: "299.99",
            item: {
              details: "After 25 years, Dr. Dre was tired of spending months on a track only to have his fans hear it on weak, distorting earbuds. Two years and hundreds of prototypes later, Beats Studio headphones are the icons that bring you sound the way it was originally intended.",
              image: "drdre_beats_headphones.jpg",
              name: "Beats by Dr. Dre Headphones"
            }
          }, {
            itemPrice: "13.00",
            item: {
              details: "Based on more than forty interviews with Jobs conducted over two years, Walter Isaacson has written a riveting story of the roller-coaster life and searingly intense personality of a creative entrepreneur whose passion for perfection and ferocious drive shook the world.",
              image: "steve-jobs-biography.jpg",
              name: "Steve Jobs by Walter Isaacson"
            }
          }, {
            itemPrice: "19.99",
            item: {
              details: "Surprise your significant other or brighten up your home decor with this beautiful flower arrangement.",
              image: "flowers.jpg",
              name: "Floral Arrangement"
            }
          }, {
            itemPrice: "16.95",
            item: {
              details: "In his first mission as 007, James Bond must win a poker game at The Casino Royale, in Montenegro, to stop a criminal who works as a banker to the terrorist organizations of the world, from financing crime and terrorism across the globe.",
              image: "007.jpg",
              name: "BluRay - Casino Royale"
            }
          }, {
            itemPrice: "44.99",
            item: {
              details: "Made with 100% leather, this is a one size, one-color bag created by designer Alexa Hobo. The is one inner zip pocket, one mobile pocket and one slip pocket.",
              image: "hobo.png",
              name: "Alexa Hobo Bag"
            }
          }, {
            itemPrice: "12.95",
            item: {
              details: "My World 2.0 is the second studio album by Canadian recording artist Justin Bieber, released on June 15, 2011 by Island Records. With a global fan base, termed as 'Beliebers', and over 30 million followers on Twitter, Justin Bieber was named by Forbes magazine in 2012 as the third-most powerful celebrity in the world. Buy his newest best selling album today. ",
              image: "justin.jpg",
              name: "Justin Beiber - My World 2.0"
            }
          }, {
            itemPrice: "46.95",
            item: {
              details: "The American Colonies, 1775. It’s a time of civil unrest and political upheaval in the Americas. As a Native American assassin fights to protect his land and his people, he will ignite the flames of a young nation’s revolution. Assassin’s Creed III takes you back to the American Revolutionary War, but not the one you’ve read about in history books.",
              image: "Assassins-Creed-3-box-art-.jpg",
              name: "Assassin's Creed III"
            }
          }, {
            itemPrice: "5.95",
            item: {
              details: "This RFID Blocking Wallet is a high-quality leather billfold with a built in Faraday cage to block RFID transmissions. It has room for six credit cards, your cash, business cards and your ID. Don't get caught unprotected!",
              image: "rfid_wallet_closed.jpg",
              name: "RFID Blocking Wallet"
            }
          }, {
            itemPrice: "9.99",
            item: {
              details: "Use this iPhone tripod to shoot steady videos and images. This stand will also allow you to conduct hands-free video calls or comfortably watch a movie. Just attach your phone onto the holder and enjoy a handsfree experience!",
              image: "slingshot.jpg",
              name: "iPhone Tripod"
            }
          }
        ]
      }
    ]
  };

  OfflineApi = (function() {

    function OfflineApi() {}

    OfflineApi.prototype.call = function(endpoint, callbacks, data) {
      if (data == null) {
        data = {};
      }
      console.debug("Offline api call to endpoint `" + endpoint + "`.");
      return typeof callbacks.success === "function" ? callbacks.success(data) : void 0;
    };

    return OfflineApi;

  })();

  OfflineAuthApi = (function(_super) {

    __extends(OfflineAuthApi, _super);

    function OfflineAuthApi() {
      return OfflineAuthApi.__super__.constructor.apply(this, arguments);
    }

    OfflineAuthApi.prototype.validate = function(email, password, callbacks) {
      return this.call('validate', callbacks);
    };

    OfflineAuthApi.prototype.register = function(email, password, callbacks) {
      return this.call('register', callbacks);
    };

    return OfflineAuthApi;

  })(OfflineApi);

  OfflinePurchaseApi = (function(_super) {

    __extends(OfflinePurchaseApi, _super);

    function OfflinePurchaseApi() {
      return OfflinePurchaseApi.__super__.constructor.apply(this, arguments);
    }

    OfflinePurchaseApi.prototype.getToken = function(address, itemspot, successUrl, cancelUrl, callbacks) {
      return this.call('getToken', callbacks, {
        token: 'offline_mode_fake_token'
      });
    };

    return OfflinePurchaseApi;

  })(OfflineApi);

  App.loadOfflineData = (function() {
    var loadBoutiques, loadUser, patchApi;
    loadUser = function(_arg) {
      var account, addresses, controller, email, password, user;
      email = _arg.email, password = _arg.password, account = _arg.account;
      console.debug('\nuser:');
      controller = new App.Controllers.LocalStorageCredentialStore();
      controller.save(email, password);
      App.auth.initialize();
      user = App.auth.user;
      addresses = user.getAddresses();
      return addresses.add(account.addresses);
    };
    loadBoutiques = function(boutiques) {
      var boutique, _i, _len, _ref, _results;
      console.debug('\nboutiques:');
      _ref = OfflineData.boutiques;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        boutique = _ref[_i];
        boutique.itemSpots = _.map(boutique.itemSpots, function(itemspot, index) {
          var image;
          image = itemspot.item.image;
          itemspot.item.image = App.OfflineImages[image];
          itemspot.index = index + 1;
          return itemspot;
        });
        console.debug("- " + boutique.code);
        _results.push(App.collections.boutiques.add(boutique));
      }
      return _results;
    };
    patchApi = function() {
      console.debug("\nPatching api.");
      App.api.auth = new OfflineAuthApi();
      return App.api.purchase = new OfflinePurchaseApi();
    };
    return function() {
      console.debug('Loading offline data...');
      console.debug('––––––––––––––––––––––––––––––––––––––––––––––');
      loadUser(OfflineData.user);
      loadBoutiques(OfflineData.boutiques);
      patchApi();
      return console.debug('\n––––––––––––––––––––––––––––––––––––––––––––––');
    };
  })();

}).call(this);
