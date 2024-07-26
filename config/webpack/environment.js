const { environment } = require("@rails/webpacker");
const handlebars = require("./loaders/handlebars");

environment.loaders.prepend("handlebars", handlebars);
module.exports = environment;
