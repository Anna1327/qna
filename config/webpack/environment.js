const { environment } = require("@rails/webpacker");

const webpack = require("webpack");
environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery/src/jquery",
    jQuery: "jquery/src/jquery",
  })
);
const Dotenv = require("dotenv-webpack");
environment.plugins.prepend("Dotenv", new Dotenv());

module.exports = environment;
