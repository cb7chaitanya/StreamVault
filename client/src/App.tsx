import { BrowserRouter, Route, Routes } from "react-router-dom"
import { RecoilRoot } from "recoil"
import Landing from "./pages/Landing"

const App = () => {
  return (
    <div>
        <RecoilRoot>
            <BrowserRouter>
                <Routes>
                    <Route path="/" element={<Landing />} />
                </Routes>
            </BrowserRouter>
        </RecoilRoot>
    </div>
  )
}

export default App