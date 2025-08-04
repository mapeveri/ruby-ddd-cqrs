import Chat from './components/Chat.tsx';

export default function App() {
  return (
    <div className="flex flex-col h-screen w-screen items-center justify-center">
      <div className="h-full w-full max-w-3xl">
        <Chat />
      </div>
    </div>
  );
}
