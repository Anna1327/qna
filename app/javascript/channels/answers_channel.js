import JsonpTemplatePlugin from "webpack/lib/web/JsonpTemplatePlugin";
import consumer from "./consumer";

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    console.log("AnswersChannel connected");
    this.perform("follow", { question_id: gon.question_id });
  },

  disconnected() {
    console.log("AnswersChannel disconnected");
  },

  received(data) {
    if (data["author_id"] === gon.current_user_id) {
      return;
    }
    if (!location.pathname.endsWith(data["question_id"])) {
      return;
    }
  },
});
