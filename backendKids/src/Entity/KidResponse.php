<?php

namespace App\Entity;

use App\Repository\KidResponseRepository;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: KidResponseRepository::class)]
class KidResponse
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(inversedBy: 'responses')]
    #[ORM\JoinColumn(nullable: false)]
    private ?Quiz $quiz = null;

    #[ORM\ManyToOne(inversedBy: 'responses')]
    private ?Kid $kid = null;

    #[ORM\OneToOne(mappedBy: 'response', cascade: ['persist', 'remove'])]
    private ?Option $optionResponse = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getQuiz(): ?Quiz
    {
        return $this->quiz;
    }

    public function setQuiz(?Quiz $quiz): static
    {
        $this->quiz = $quiz;

        return $this;
    }

    public function getKid(): ?Kid
    {
        return $this->kid;
    }

    public function setKid(?Kid $kid): static
    {
        $this->kid = $kid;

        return $this;
    }

    public function getOptionResponse(): ?Option
    {
        return $this->optionResponse;
    }

    public function setOptionResponse(?Option $optionResponse): static
    {
        // unset the owning side of the relation if necessary
        if ($optionResponse === null && $this->optionResponse !== null) {
            $this->optionResponse->setResponse(null);
        }

        // set the owning side of the relation if necessary
        if ($optionResponse !== null && $optionResponse->getResponse() !== $this) {
            $optionResponse->setResponse($this);
        }

        $this->optionResponse = $optionResponse;

        return $this;
    }
}
