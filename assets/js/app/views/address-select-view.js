(function() {
  var AddressListItemView, AddressListView,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.AddressSelect = (function(_super) {

    __extends(AddressSelect, _super);

    function AddressSelect() {
      return AddressSelect.__super__.constructor.apply(this, arguments);
    }

    AddressSelect.prototype.template = 'address-select';

    AddressSelect.prototype.className = 'address-select';

    AddressSelect.prototype.initialize = function(options) {
      AddressSelect.__super__.initialize.apply(this, arguments);
      this.addressListView = new AddressListView({
        collection: this.collection
      });
      return this.setView(this.addressListView);
    };

    AddressSelect.prototype.validateForm = function(callbacks) {
      return callbacks.success({});
    };

    AddressSelect.prototype.submitForm = function(cleanedFields, callbacks) {
      var address;
      address = this.addressListView.selectedAddressView.model;
      return callbacks.success({
        address: address
      });
    };

    return AddressSelect;

  })(App.Views.AddressModeView);

  AddressListView = (function(_super) {

    __extends(AddressListView, _super);

    function AddressListView() {
      return AddressListView.__super__.constructor.apply(this, arguments);
    }

    AddressListView.prototype.tagName = 'ul';

    AddressListView.prototype.className = 'addresses';

    AddressListView.prototype.events = {
      'click .remove': 'removeClicked'
    };

    AddressListView.prototype.selectedAddressView = null;

    AddressListView.prototype.selectAddressView = function(addressView) {
      var _ref;
      if ((_ref = this.selectedAddressView) != null) {
        _ref.deselect();
      }
      this.selectedAddressView = addressView;
      return this.selectedAddressView.select();
    };

    AddressListView.prototype.removeClicked = function() {
      return this.render();
    };

    AddressListView.prototype.beforeRender = function() {
      var _this = this;
      return this.collection.each(function(address, index) {
        var addressView, firstAddress;
        firstAddress = index === 0;
        addressView = new AddressListItemView({
          parent: _this,
          selected: firstAddress,
          model: address
        });
        if (firstAddress) {
          _this.selectedAddressView = addressView;
        }
        return _this.insertView(addressView);
      });
    };

    return AddressListView;

  })(Backbone.LayoutView);

  AddressListItemView = (function(_super) {

    __extends(AddressListItemView, _super);

    function AddressListItemView() {
      return AddressListItemView.__super__.constructor.apply(this, arguments);
    }

    AddressListItemView.prototype.template = 'address';

    AddressListItemView.prototype.tagName = 'li';

    AddressListItemView.prototype.className = 'address';

    AddressListItemView.prototype.events = {
      'click': 'clicked',
      'click .remove': 'removeClicked'
    };

    AddressListItemView.prototype.selected = false;

    AddressListItemView.prototype.initialize = function(options) {
      this.parent = options.parent;
      if (options.selected) {
        return this.select();
      }
    };

    AddressListItemView.prototype.clicked = function() {
      var _this = this;
      if (this.isSelected()) {
        return this.toggleRemoveButton();
      }
      return _.defer(function() {
        return _this.parent.selectAddressView(_this);
      });
    };

    AddressListItemView.prototype.hideRemoveButton = function() {
      return this.$el.find('.remove').hide();
    };

    AddressListItemView.prototype.toggleRemoveButton = function() {
      return this.$el.find('.remove').toggle();
    };

    AddressListItemView.prototype.removeClicked = function(event) {
      this.model.destroy();
      return true;
    };

    AddressListItemView.prototype.select = function() {
      return this.setSelected(true);
    };

    AddressListItemView.prototype.deselect = function() {
      this.setSelected(false);
      return this.hideRemoveButton();
    };

    AddressListItemView.prototype.isSelected = function() {
      return this.selected;
    };

    AddressListItemView.prototype.setSelected = function(selected) {
      this.selected = selected;
      return this.render();
    };

    AddressListItemView.prototype.serialize = function() {
      var serializedModel;
      serializedModel = this.model.toJSON();
      return _.extend(serializedModel, {
        selected: this.selected
      });
    };

    return AddressListItemView;

  })(Backbone.LayoutView);

}).call(this);
