module.exports = {
  test: /\.hbs$/,
  loader: "handlebars-loader",
  options: {
    precompileOptions: {
      knownHelpersOnly: false,
    },
  },
};
