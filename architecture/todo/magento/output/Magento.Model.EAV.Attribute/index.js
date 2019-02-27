"use strict";
var Select = (function () {
    function Select() {

    };
    Select.value = new Select();
    return Select;
})();
var Multiselect = (function () {
    function Multiselect() {

    };
    Multiselect.value = new Multiselect();
    return Multiselect;
})();
var Hidden = (function () {
    function Hidden() {

    };
    Hidden.value = new Hidden();
    return Hidden;
})();
var FrontentInput_Text = (function () {
    function FrontentInput_Text() {

    };
    FrontentInput_Text.value = new FrontentInput_Text();
    return FrontentInput_Text;
})();
var FrontentInput_Boolean = (function () {
    function FrontentInput_Boolean() {

    };
    FrontentInput_Boolean.value = new FrontentInput_Boolean();
    return FrontentInput_Boolean;
})();
var FrontentInput_Date = (function () {
    function FrontentInput_Date() {

    };
    FrontentInput_Date.value = new FrontentInput_Date();
    return FrontentInput_Date;
})();
var FrontentInput_Price = (function () {
    function FrontentInput_Price() {

    };
    FrontentInput_Price.value = new FrontentInput_Price();
    return FrontentInput_Price;
})();
var FrontentInput_Etc = (function () {
    function FrontentInput_Etc() {

    };
    FrontentInput_Etc.value = new FrontentInput_Etc();
    return FrontentInput_Etc;
})();
var Customer = (function () {
    function Customer() {

    };
    Customer.value = new Customer();
    return Customer;
})();
var CustomerAddress = (function () {
    function CustomerAddress() {

    };
    CustomerAddress.value = new CustomerAddress();
    return CustomerAddress;
})();
var CatalogCategory = (function () {
    function CatalogCategory() {

    };
    CatalogCategory.value = new CatalogCategory();
    return CatalogCategory;
})();
var Static = (function () {
    function Static() {

    };
    Static.value = new Static();
    return Static;
})();
var BackendType_Text = (function () {
    function BackendType_Text() {

    };
    BackendType_Text.value = new BackendType_Text();
    return BackendType_Text;
})();
var BackendType_DateTime = (function () {
    function BackendType_DateTime() {

    };
    BackendType_DateTime.value = new BackendType_DateTime();
    return BackendType_DateTime;
})();
var BackendType_Etc = (function () {
    function BackendType_Etc() {

    };
    BackendType_Etc.value = new BackendType_Etc();
    return BackendType_Etc;
})();
var Attribute = function (x) {
    return x;
};
module.exports = {
    Customer: Customer,
    CustomerAddress: CustomerAddress,
    CatalogCategory: CatalogCategory,
    Select: Select,
    Multiselect: Multiselect,
    Hidden: Hidden,
    FrontentInput_Text: FrontentInput_Text,
    FrontentInput_Boolean: FrontentInput_Boolean,
    FrontentInput_Date: FrontentInput_Date,
    FrontentInput_Price: FrontentInput_Price,
    FrontentInput_Etc: FrontentInput_Etc,
    Static: Static,
    BackendType_Text: BackendType_Text,
    BackendType_DateTime: BackendType_DateTime,
    BackendType_Etc: BackendType_Etc,
    Attribute: Attribute
};
