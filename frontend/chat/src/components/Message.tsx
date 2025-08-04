type Props = {
  isOwn: boolean;
  text: string;
};

export default function Message({ isOwn, text }: Props) {
  return (
    <div className={`flex ${isOwn ? 'justify-end' : 'justify-start'}`}>
      <div
        className={`max-w-[70%] px-5 py-3 rounded-xl break-words
          ${isOwn ? 'bg-indigo-600 text-white rounded-br-none shadow-md' : 'bg-white text-black rounded-bl-none shadow-sm'}
        `}
        style={{ wordBreak: 'break-word' }}
      >
        {text}
      </div>
    </div>
  );
}
