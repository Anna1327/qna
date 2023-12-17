const GistClient = require("gist-client");
const gitToken = process.env.GIT_TOKEN;

const client = new GistClient();

const isGist = (link) => {
  return link.href && link.href.startsWith("https://gist.github.com");
};

const gistPage = (gist, gistLinkName) => {
  const root = document.createElement("div");

  const gistLink = document.createElement("a");
  gistLink.innerText = gistLinkName;
  gistLink.href = gist.html_url;

  root.insertAdjacentElement("afterbegin", gistLink);

  for (const file of Object.values(gist.files)) {
    const inner = document.createElement("div");

    const fileName = document.createElement("a");
    fileName.innerText = file.filename;
    fileName.href = file.raw_url;

    const content = document.createElement("p");
    content.innerText = file.content;

    inner.insertAdjacentElement("beforeend", fileName);
    inner.insertAdjacentElement("beforeend", content);
    root.insertAdjacentElement("beforeend", inner);
  }
  return root;
};

const addGistPage = (elem, gist) => {
  const innerHTML = gistPage(gist, elem.innerText);
  elem.parentElement.innerHTML = innerHTML.innerHTML;
};

export const gistRenderer = async () => {
  for (const elem of document.querySelectorAll(".resource-link")) {
    if (isGist(elem)) {
      const gistId = elem.href.split("/")[elem.href.split("/").length - 1];
      const gist = await client.setToken(gitToken).getOneById(gistId);
      addGistPage(elem, gist);
    }
  }
};

document.addEventListener("turbolinks:load", () => {
  gistRenderer().catch((e) => console.error(e));
});

document.addEventListener("gistRenderer", () => {
  gistRenderer().catch((e) => console.error(e));
});
