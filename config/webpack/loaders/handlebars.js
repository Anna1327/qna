import Handlebars from "handlebars/runtime";

Handlebars.registerHelper("author_of?", function (author_id) {
  return author_id === gon.current_user_id;
});

Handlebars.registerHelper("can_vote?", function (author_id) {
  return gon.current_user_id && author_id !== gon.current_user_id;
});
