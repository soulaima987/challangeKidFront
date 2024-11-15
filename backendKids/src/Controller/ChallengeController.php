<?php

namespace App\Controller;

use App\Entity\Category;
use App\Entity\Challenge;
use App\Entity\Chapter;
use App\Entity\Coach;
use App\Form\ChallengeType;
use App\Form\ChapterType;
use App\Repository\ChallengeRepository;
use App\Repository\PostRepository;
use App\Service\ChallengeService;
use App\Service\CoachService;
use App\Service\PostService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

#[Route('/api/challenge')]
#[OA\Tag(name: 'challenge')]
class ChallengeController extends AbstractController
{
    private $challengeService;
    private $coachService;
    private $postService;
    private $entityManager;
    private $security;

    public function __construct(ChallengeService $challengeService, EntityManagerInterface $entityManager, CoachService $coachService, Security $security, PostService $postService)
    {
        $this->challengeService = $challengeService;
        $this->entityManager = $entityManager;
        $this->coachService = $coachService;
        $this->security = $security;
        $this->postService = $postService;
    }

    #[Route('/', name: 'challenge_index', methods: ['GET'])]
    public function index(ChallengeRepository $challengeRepository): JsonResponse
    {
        $listJson = [];
        $list = $challengeRepository->findAll();
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->challengeService->challengeToJson($value);
        }

        return new JsonResponse($listJson);
    }

    #[Route('/coach', name: 'challenge_coach_show', methods: ['GET'])]
    public function getCoachChallenges(ChallengeRepository $challengeRepository): JsonResponse
    {
        $user = $this->security->getUser();
        $listJson = [];
        $list = $challengeRepository->findBy(["coach" => $user]);
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->challengeService->challengeToJson($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/{id}', name: 'challenge_show', methods: ['GET'])]
    public function show(ChallengeRepository $challengeRepository, $id): JsonResponse
    {
        $challenge = $challengeRepository->find($id);
        $challenge = $this->challengeService->challengeToJson($challenge);
        return new JsonResponse($challenge);
    }

    #[Route('/{id}/edit', name: 'challenge_edit', methods: ['PUT'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "title" => "Challenge1",
                "description" => "This is a description for the 1st Challenge",
                "categories" => ["Art", "Science", "Music"],
            ]
        )
    )]
    public function edit($id, Request $request, ChallengeRepository $challengeRepository, EntityManagerInterface $entityManager): JsonResponse
    {
        $challenge = $challengeRepository->find($id);

        $data = json_decode($request->getContent(), true);
        $form = $this->createForm(ChallengeType::class, $challenge);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $entityManager->persist($challenge);
            $entityManager->flush();

            return new JsonResponse(['status' => 'Challenge updated successfully']);
        }

        return new JsonResponse(['error' => 'An error has occured']);
    }

    #[Route('/delete/{id}', name: 'challenge_delete', methods: ['DELETE'])]
    public function delete($id, ChallengeRepository $challengeRepository, EntityManagerInterface $entityManager): Response
    {
        $challenge = $challengeRepository->find($id);
        if (!$challenge) {
            throw new NotFoundHttpException('Challenge not found');
        }

        $entityManager->remove($challenge);
        $entityManager->flush();

        return new JsonResponse(['status' => 'The Challenge has been deleted']);
    }
    #[Route('/coach/addChallenge', name: 'challenge_add_image', methods: ['POST'])]
    #[OA\Post(
        summary: 'Add a new Challenge Image',
        description: 'Add Challenge Image',
        requestBody: new OA\RequestBody(
            description: 'Request body for adding a new Image Challenge',
            required: true,
            content: [
                'multipart/form-data' => new OA\MediaType(
                    mediaType: 'multipart/form-data',
                    schema: new OA\Schema(
                        type: 'object',
                        properties: [
                            new OA\Property(
                                property: 'title',
                                type: 'string',
                                example: 'hadil'
                            ),
                            new OA\Property(
                                property: 'description',
                                type: 'string',
                                example: 'tahki yasser'
                            ),
                            new OA\Property(
                                property: 'imageFileName',
                                type: 'string',
                                format: 'binary',
                                description: 'File to upload'
                            ),
                            new OA\Property(
                                property: 'categories',
                                type: 'array',
                                items: new OA\Items(
                                    type: 'string',
                                    example: 'Category1'
                                ),
                                description: 'List of category titles'
                            )
                        ]
                    )
                )
            ]
        )
    )]
    public function addChallenge(Request $request): JsonResponse
    {
        $user = $this->security->getUser();

        $title = $request->request->get('title');
        $description = $request->request->get('description');
        $imageFile = $request->files->get('imageFileName');
        $categoryTitlesJson  = $request->request->get('categories');
        $categoryTitles = json_decode($categoryTitlesJson, true);


        $challenge = new Challenge();
        $challenge->setTitle($title);
        $challenge->setDescription($description);
        $challenge->setCoach($user);


        if ($imageFile instanceof UploadedFile) {

            $fileName = uniqid() . '.' . $imageFile->guessExtension();

            $uploadsDirectory = $this->getParameter('kernel.project_dir') . '/public/uploads/images';

            $imageFile->move($uploadsDirectory, $fileName);

            $challenge->setImageFileName($fileName);
        } else {

            return new JsonResponse(['message' => 'File upload failed or not recognized.']);
        }

        if (is_array($categoryTitles)) {

            foreach ($categoryTitles as $categoryTitle) {
                $category = $this->entityManager->getRepository(Category::class)->findOneBy(['title' => $categoryTitle]);
                if ($category) {
                    $challenge->addCategory($category);
                }
            }
        } else {
            return new JsonResponse("failed to load categories");
        }

        $this->entityManager->persist($challenge);
        $this->entityManager->flush();

        return new JsonResponse(['success' => true, 'message' => 'Image Added successfully.']);
    }

    #[Route('/{challengeId}/coach', name: 'challenge_get_coach', methods: ['GET'])]
    public function getCoach($challengeId)
    {
        $challenge = $this->entityManager->getRepository(Challenge::class)->find($challengeId);
        $coach = $challenge->getCoach();
        $coach = $this->coachService->coachToJson($coach);
        return new JsonResponse($coach);
    }

    #[Route('/{id}/addChapters', name: 'chapter_add_challenge', methods: ['PUT'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "chapters" => ["Chapter1", "Chapter3", "Chapter5"],
            ]
        )
    )]
    public function addChapters($id, Request $request, ChallengeRepository $challengeRepository): JsonResponse
    {
        $challenge = $challengeRepository->find($id);
        $data = $request->toArray();
        $chapterTitles = $data["chapters"];
        $this->challengeService->addChapters($challenge, $chapterTitles);

        return new JsonResponse(true);
    }

    #[Route('/{challengeId}/createChapter', name: 'challenge_create_chapter', methods: ['POST'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "title" => "Chapter5",
                "description" => "This is a description for the 5th Chapter",
                "chapterNumber" => 5
            ]
        )
    )]
    public function createChapterForChallenge($challengeId, Request $request, ChallengeRepository $challengeRepository, EntityManagerInterface $entityManager): Response
    {
        $user = $this->security->getUser();

        $challenge = $challengeRepository->find($challengeId);

        $data = json_decode($request->getContent(), true);

        $chapter = new Chapter();
        $chapter->setCoach($user);
        $form = $this->createForm(ChapterType::class, $chapter);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $challenge->addChapter($chapter);
            $entityManager->persist($challenge);
            $entityManager->persist($chapter);
            $entityManager->flush();
        }

        return new JsonResponse(true);
    }

    #[Route('/{id}/submissions', name: 'challenge_submissions', methods: ['GET'], requirements: ['id' => '\d+'])]
    public function viewSubmissions(int $id, PostRepository $postRepository): Response
    {

        $listJson = [];
        $posts = $postRepository->findByChallengeIdAndKid($id);

        foreach ($posts as $key => $value) {
            $listJson[$key] = $this->postService->postToJson($value);
        }

        return new JsonResponse($listJson);
    }

    #[Route('/coach/{coachId}', name: 'challenge_ids_by_caoch', methods: ['GET'], requirements: ['coachId' => '\d+'])]
    public function challengeIds(int $coachId, ChallengeRepository $challengeRepository): Response
    {

        $challengeIds = $challengeRepository->findChallengeIdsByCoach($coachId);

        return new JsonResponse($challengeIds);
    }
}
