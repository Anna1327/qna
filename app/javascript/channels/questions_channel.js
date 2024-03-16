import consumer from "./consumer";

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    console.log("QuestionsChannel connected!");
    this.perform("follow");
  },

  disconnected() {
    console.log("QuestionsChannel disconnected!");
  },

  received(data) {
    const tableBody = document.querySelector("tbody");
    const newRow = document.createElement("tr");
    newRow.innerHTML = data;
    tableBody.insertAdjacentHTML("beforeend", newRow.outerHTML);
  },
});
