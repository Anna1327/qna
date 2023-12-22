document.addEventListener("turbolinks:load", () => {
  const votes = document.querySelector(".question .votes");
  if (votes) {
    votes.addEventListener("ajax:success", (event) => {
      const vote = event.detail[0];
      votes.querySelector(".count").textContent = vote.vote_count;
    });

    votes.addEventListener("ajax:error", (event) => {
      for (const error of event.detail[0]) {
        document
          .querySelector(".question_errors")
          .insertAdjacentHTML("beforeend", `${error}`);
      }
    });
  }
});
