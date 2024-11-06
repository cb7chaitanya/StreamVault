import { BrowserRouter, Route, Routes } from "react-router-dom"
import { RecoilRoot } from "recoil"
import Landing from "./pages/Landing"
import Videos from "./pages/Videos"

const App = () => {
  return (
    <div>
        <RecoilRoot>
            <BrowserRouter>
                <Routes>
                    <Route path="/" element={<Landing />} />
                    <Route path="/videos" element={<Videos />} />
                </Routes>
            </BrowserRouter>
        </RecoilRoot>
    </div>
  )
}

export default App