const Handlebars = require("handlebars");

module.exports = {
  module: {
    rules: [{ test: /\.hbs$/, use: "html-loader" }],
  },
  plugins: [
    new Handlebars({ template: "app/javascript/templates/answer.hbs" }),
  ],
};
