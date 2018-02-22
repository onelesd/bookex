import debounce from 'debounce-promise'
import { h, app } from 'hyperapp'
import logger from '@hyperapp/logger'
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
    {
      bookData: bookData.books,
      selectedBook: null
    }
  )
}

const view = (state, actions) => (
  <div class='main'>
    <div class='bookSearch'>
      <input type='text'
             placeholder='Search book titles'
             value={state.titleSearchText}
             oninput={e => actions.updateTitleSearchText(e.target.value)}/>
    </div>
    <div class='bookList'>
      {
        state.bookData.map((book, idx) => (
          <div class='bookList__item' onclick={() => actions.selectBook(idx)}>
            <img src={book.thumb_url}/>
            {book.title}
          </div>
        ))
      }
    </div>
    {
      state.selectedBook != null ? (
        <div class='bookList__item bookList__selected'>
          <div>
            <img src={state.bookData[state.selectedBook].image_url}/>
            {state.bookData[state.selectedBook].title}
          </div>
        </div>
      ) : (
        <div></div>
      )
    }
  </div>
)

logger({})(app)(state, actions, view, document.body) // dev
// app(state, actions, view, document.body) // prod
