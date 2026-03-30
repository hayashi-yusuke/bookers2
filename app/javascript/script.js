import Raty from "raty-js"

document.addEventListener("turbo:load", () => {
  // 投稿フォームの星評価（入力用）
  const elem = document.querySelector("#post_raty");
  if (elem){
  new Raty(elem, {
    scoreName: "book[score]",
    starOn: elem.dataset.starOn,
    starOff: elem.dataset.starOff,
  }).init();
  }

    // 詳細ページの星評価（表示用）
  document.querySelectorAll("[id^='show_raty_']").forEach((el) => {
    const score = el.dataset.score;
    new Raty(el, {
      readOnly: true,
      score: score,
      starOn: el.dataset.starOn,
      starOff: el.dataset.starOff,
    }).init();
  });
});