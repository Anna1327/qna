const comments = () => {
  const createComments = document.querySelectorAll(".create-comment");
  if (createComments.length) {
    createComments.forEach((createComment) => {
      createComment.addEventListener("ajax:error", (event) => {
        const errors = event.target.querySelector(".errors");
        const errorsList = document.createElement("ul");
        for (const error of event.detail[0]) {
          errorsList.insertAdjacentHTML("afterbegin", `<li>${error}</li>`);
        }
        errors.insertAdjacentElement("afterbegin", errorsList);
      });
      createComment.addEventListener("ajax:success", (event) => {
        const oneComment = event.detail[0];
        event.target.querySelector(".errors").innerHTML = "";
        const elId = `${oneComment.comment.commentable_type.toLowerCase()}-${
          oneComment.comment.commentable_id
        }`;
        document.querySelector(`#${elId} #comment_body`).value = "";
      });
    });
  }
};

document.addEventListener("turbolinks:load", () => {
  comments();
});
