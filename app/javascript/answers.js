document.addEventListener("turbolinks:load", () => {
  const answers = document.querySelector(".answers");
  if (answers) {
    answers.addEventListener("click", (event) => {
      if (event.target.classList.contains("edit-answer-link")) {
        event.preventDefault();
        event.target.classList.add("hidden");
        const answerId = event.target.dataset.answerId;
        document
          .querySelector(`form#edit-answer-${answerId}`)
          .classList.toggle("hidden");
      }
    });
  }
});
