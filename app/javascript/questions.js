document.addEventListener("turbolinks:load", () => {
  const question = document.querySelector(".question");
  if (question) {
    question.addEventListener("click", (event) => {
      if (event.target.classList.contains("edit-question-link")) {
        event.preventDefault();
        event.target.classList.add("hidden");
        question.querySelector("form").classList.toggle("hidden");
      }
    });
  }
});
