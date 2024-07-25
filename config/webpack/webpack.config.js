module.exports = {
  module: {
    rules: [{ test: /\.hbs$/, use: "handlebars-loader" }],
  },
  plugins: [
    new Handlebars({ template: "app/javascript/templates/answer.hbs" }),
  ],
};
