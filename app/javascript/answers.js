document.addEventListener("turbolinks:load", () => {
  const answers = document.querySelector(".answers");
  if (answers) {
    answers.addEventListener("click", (event) => {
      if (event.target.classList.contains("edit-answer-link")) {
        event.preventDefault();
        const answerId = event.target.dataset.answerId;
        event.target.classList.add("hidden");
        document
          .querySelector(`form#edit-answer-${answerId}`)
          .classList.toggle("hidden");
      }
    });
  }
});
