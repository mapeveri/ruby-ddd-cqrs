import { useEffect, useRef } from 'react';
import ActionCable from 'actioncable';

type MessageType = {
  id: string;
  sender_id: string;
  receiver_id: string;
  chat_id: string;
  content: string;
};

let cable: ActionCable.Cable | null = null;

export function useCable(chatId: string, onMessage: (msg: MessageType) => void) {
  const subscriptionRef = useRef<any>(null);

  useEffect(() => {
    if (!cable) {
      cable = ActionCable.createConsumer('ws://localhost:3000/cable');
    }

    subscriptionRef.current = cable.subscriptions.create(
      { channel: 'ChatChannel', chat_id: chatId },
      {
        received(data: string) {
          const message: MessageType = JSON.parse(data)
          onMessage(message);
        },
      }
    );

    return () => {
      if (subscriptionRef.current) {
        subscriptionRef.current.unsubscribe();
      }
    };
  }, [chatId, onMessage]);
}
