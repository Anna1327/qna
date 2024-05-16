import consumer from "./consumer";

consumer.subscriptions.create(
  { channel: "CommentsChannel", question_id: gon.question_id },
  {
    connected() {
      console.log("CommentsChannel connected");
      this.perform("follow");
    },

    disconnected() {
      console.log("CommentsChannel disconnected");
    },

    received(data) {
      console.log(data);
      if (data.action === "create") {
        const comment = require("templates/comment.hbs")(data.comment);
        const selector = `#${data.comment.commentable_type.toLowerCase()}-${
          data.comment.commentable_id
        } .comments`;

        console.log(selector);

        document
          .querySelector(selector)
          .insertAdjacentHTML("beforeend", comment);
      } else if (data.action === "delete") {
        const comment = document.getElementById(
          `comment_id_${data.comment_id}`
        );
        comment.parentNode.removeChild(comment);
      }
    },
  }
);
