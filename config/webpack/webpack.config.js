const Handlebars = require("handlebars");

module.exports = {
  module: {
    rules: [
      {
        test: /\.hbs$/i,
        loader: "html-loader",
        options: {
          preprocessor: async (content, loaderContext) => {
            let result;

            try {
              result = await Handlebars.compile(content)({
                firstname: "Value",
                lastname: "OtherValue",
              });
            } catch (error) {
              await loaderContext.emitError(error);

              return content;
            }

            return result;
          },
        },
      },
    ],
  },
};
