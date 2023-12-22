document.addEventListener("turbolinks:load", () => {
  const votes = document.querySelector(".question .votes");
  if (votes) {
    votes.addEventListener("ajax:success", (event) => {
      document.querySelector(".question .votes").innerHTML =
        event.detail[2].responseText;
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
