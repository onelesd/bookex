import debounce from 'debounce-promise'
import { h, app } from 'hyperapp'
import 'normalize.css'
import '../css/app.sass'

const state = {
  titleSearchText: '',
  bookData: [],
  selectedBook: null
}

// goodreads api advertises a rate limit of 1s
const getBookData = debounce(value => {
  return fetch(`/api/v1/search_book/${value}`)
    .then(res => res.json())
}, 1000)

const actions = {
  updateTitleSearchText: (titleSearchText) => (state, actions) => {
    getBookData(titleSearchText)
      .then(actions.setBookData)
    return {titleSearchText}
  },
  selectBook: selectedBook => state => (
    {selectedBook}
  ),
  setBookData: bookData => state => (
    {bookData: bookData.books}
  )
}

const view = (state, actions) => (
  <div class='main'>
    <h1>Search book titles</h1>
    <input type='text'
          value={state.titleSearchText}
          oninput={e => actions.updateTitleSearchText(e.target.value)}/>
    <div class="bookList">
      {
        state.bookData.map((book, idx) => (
          <div onclick={() => actions.selectBook(idx)}>
            <img src={book.thumb_url}/>
            {book.title}
          </div>
        ))
      }
    </div>
    <div class='showBook'>
    {
      state.selectedBook ? (
        <div>
          <img src={state.bookData[state.selectedBook].image_url}/>
          {state.bookData[state.selectedBook].title}
        </div>
      ) : (
        <div></div>
      )
    }
    </div>
  </div>
)

app(
  state,
  actions,
  // view,
  function(state, actions) {
    console.log(state)
    return view(state, actions)
  },
  document.body
)
