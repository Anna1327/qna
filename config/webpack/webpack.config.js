module.exports = {
  entry: {
    main: "./javascript/templates/answer.hbs",
  },
  module: {
    rules: [
      {
        test: /\.hbs$/,
        use: {
          loader: "handlebars-loader",
          options: {
            presets: ["@babel/preset-env", "@babel/preset-typescript"],
          },
        },
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: [".hbs"],
  },
  plugins: [new webpack.CleanPlugin()],
  output: {
    filename: "[name].[contenthash].html",
    path: path.join(__dirname, "dist"),
  },
};
