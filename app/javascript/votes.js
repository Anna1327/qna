document.addEventListener("turbolinks:load", () => {
  const votes = document.querySelectorAll(".votes");
  if (votes.length) {
    votes.forEach((elem) => {
      elem.addEventListener("ajax:success", (event) => {
        const votable_class = event.detail[0]["votable_class"];
        const votable_id = event.detail[0]["votable_id"];
        const vote_count = event.detail[0]["vote_count"];
        if (
          elem.dataset.resourceName === votable_class &&
          elem.dataset.resourceId == votable_id
        ) {
          elem.querySelector(".count").textContent = vote_count;
        }
      });

      elem.addEventListener("ajax:error", (event) => {
        for (const error of event.detail[0]) {
          document
            .querySelector(".question_errors")
            .insertAdjacentHTML("beforeend", `${error}`);
        }
      });
    });
  }
});
